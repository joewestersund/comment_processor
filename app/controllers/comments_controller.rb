class CommentsController < ApplicationController
  include CommentsHelper
  include ChangeLogEntriesHelper
  include ActionController::Live
  require 'csv'

  before_action :signed_in_user
  before_action :admin_user, only: [:new, :create, :import, :destroy, :do_import, :cleanup, :do_cleanup]
  before_action :not_read_only_user, only: [:edit, :update]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_select_options, only: [:new, :edit, :index ]

  # GET /comments
  # GET /comments.json
  def index
    cr = current_rulemaking
    conditions = get_conditions
    if conditions[0].empty?
      c = cr.comments.all
    else
      #do left outer join in case there are no conditions on suggested_changes
      c = cr.comments.where("id IN (?)", cr.comments.left_outer_joins(:suggested_changes).where(conditions).select(:id))
    end
    c = c.order(:order_in_list)

    respond_to do |format|
      format.html {
        @total_comments = cr.comments.count
        @total_commenters = cr.comments.sum(:num_commenters)
        @filtered = !conditions[0].empty?
        @filter_querystring = remove_empty_elements(filter_params_all)
        @comments = c.page(params[:page]).per_page(10)
      }
      format.xlsx {
        @comments = c
        response.headers['Content-Disposition'] = 'attachment; filename="comments.xlsx"'
      }
      format.csv {
        stream_csv(c)
      }
    end


  end

  def import
    #import comments from an outside data source
    @comment_data_sources = current_rulemaking.comment_data_sources.where(active:true).order(:data_source_name).all

  end

  def do_import
    #actually do the import
    cds = current_rulemaking.comment_data_sources.find_by(id: comment_import_params[:comment_data_source_id])
    comments_imported = import_comments_data(cds)
    save_change_log(current_user,{object_type: 'comment', action_type: 'import', description: "imported #{comments_imported} comments into the database from #{cds.data_source_name}."}) if comments_imported > 0
    redirect_to comments_path, notice: "#{comments_imported} comment(s) were successfully imported into the database."
  end

  def cleanup
    #clean up HTML escape characters in the comment text
    @characters_to_clean_up = escape_characters_to_replace
  end

  def do_cleanup
    #actually do the cleanup
    current_rulemaking.comments.each do |c|
      c.comment_text = clean_text(c.comment_text)
      c.organization = clean_text(c.organization)
      c.save
    end

    save_change_log(current_user,{object_type: 'comment', action_type: 'clean up', description: "ran the cleanup process to remove HTML escape characters from the database."})
    redirect_to comments_path, notice: "HTML escape characters were successfully cleaned from the comment text."
  end

  # GET /comments/new
  def new
    @comment = Comment.new
    #this is only used when someone's manually entering a comment
    @comment.rulemaking = current_rulemaking
    @comment.manually_entered = true
    @comment.num_commenters = 1
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    get_filtering_and_next_and_previous
    @change_log_entries = current_rulemaking.change_log_entries.where(comment: @comment).order(created_at: :desc).page(params[:page]).per_page(10)
  end

  # GET /comments/1/edit
  def edit
    get_filtering_and_next_and_previous
    @change_log_entries = current_rulemaking.change_log_entries.where(comment: @comment).order(created_at: :desc).page(params[:page]).per_page(10)
  end

  # POST /comments
  # POST /comments.json
  def create
    # we only get here if this comment is being manually entered.
    @comment = Comment.new(comment_params)

    c_max = Comment.maximum(:order_in_list)
    next_order_in_list = (c_max.nil? ? 0 : c_max) + 1
    @comment.order_in_list = next_order_in_list

    @comment.rulemaking = current_rulemaking
    @comment.manually_entered = true

    respond_to do |format|
      if @comment.save
        suggested_change_change_hash = save_suggested_changes
        save_change_log(current_user,{comment: @comment, suggested_change_changes: suggested_change_change_hash, action_type: 'create'})
        format.html { redirect_to edit_comment_path(@comment), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        set_select_options
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update

    respond_to do |format|
      if @comment.update(comment_params)
        suggested_change_change_hash = save_suggested_changes
        save_change_log(current_user,{comment: @comment, suggested_change_changes: suggested_change_change_hash, action_type: 'edit'})
        @filter_querystring = remove_empty_elements(filter_params_all)
        format.html { redirect_to edit_comment_path(@comment,@filter_querystring), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        set_select_options
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    current_comment_num = @comment.order_in_list
    #note: can't associate this change log entry with the comment object, because the comment is about to be destroyed.
    save_change_log(current_user,{object_type: 'comment', action_type: 'delete', description: "deleted comment ID ##{@comment.id} from #{@comment.first_name} #{@comment.last_name}, '#{@comment.comment_text.truncate(1000) if @comment.comment_text.present?}'"})
    @comment.destroy
    handle_delete_of_order_in_list(current_rulemaking.comments,current_comment_num)
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    def get_filtering_and_next_and_previous
      current_comment_order_in_list = @comment.order_in_list

      conditions = get_conditions
      if conditions[0].empty?
        c = current_rulemaking.comments.all
      else
        #do left outer join in case there are no conditions on suggested_changes
        c = current_rulemaking.comments.where("id IN (?)", current_rulemaking.comments.left_outer_joins(:suggested_changes).where(conditions).select(:id))
      end

      @previous_comment = c.where("order_in_list < ?", current_comment_order_in_list).order(:order_in_list).last
      @next_comment = c.where("order_in_list > ?", current_comment_order_in_list).order(:order_in_list).first

      @filtered = !conditions[0].empty?
      @filter_querystring = remove_empty_elements(filter_params_all)
    end

    def save_suggested_changes
      previous_suggested_changes = @comment.suggested_changes.map { |cat| get_suggested_change_description(cat)}
      @suggested_changes = current_rulemaking.suggested_changes.where(:id => params[:comment_suggested_changes])
      @comment.suggested_changes.destroy_all
      @comment.suggested_changes << @suggested_changes
      #subtract out any suggested_change IDs that were there before and still are after
      new_suggested_changes = @suggested_changes.map { |cat| get_suggested_change_description(cat)}
      in_both = new_suggested_changes & previous_suggested_changes
      {removed: (previous_suggested_changes - in_both).sort!, added: (new_suggested_changes - in_both).sort! }
    end

    def get_suggested_change_description(suggested_change)
      "##{suggested_change.id} '#{suggested_change.suggested_change_name.truncate(100)}'"
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = current_rulemaking.comments.find_by(id: params[:id])
      if @comment.nil?
        respond_to do |format|
          format.html { redirect_to comments_url, alert: "Comment #{params[:id]} was not found." }
          format.json { head :no_content }
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.

    def comment_params
      params.require(:comment).permit(:source_id, :first_name, :last_name, :email, :organization, :state, :comment_text, :attachment_name, :attachment_url, :num_commenters, :summary, :comment_status_type_id, :notes, :manually_entered, :comment_data_source_id)
    end

    def comment_import_params
      params.permit(:comment_data_source_id)
    end

    def set_select_options
      cr = current_rulemaking
      @suggested_changes = cr.suggested_changes.order('LOWER(suggested_change_name)').all
      @comment_status_types = cr.comment_status_types.order(:order_in_list).all
      @comment_data_sources = cr.comment_data_sources.order(:id).all
    end

    def filter_params_in_obj
      params.permit(:first_name, :last_name, :email, :organization, :state, :comment_text, :summary, :comment_status_type_id, :notes, :manually_entered, :comment_data_source_id)
    end

    def filter_params_all
      params.permit(:first_name, :last_name, :email, :organization, :state, :comment_text, :summary, :comment_status_type_id, :notes, :manually_entered, :comment_data_source_id, :has_attachment, :suggested_change_id, )
    end

    def get_conditions

      search_terms = Comment.new(filter_params_in_obj)

      conditions = {}
      conditions_string = []

      conditions[:comment_data_source_id] = search_terms.comment_data_source_id if search_terms.comment_data_source_id.present?
      conditions_string << "comment_data_source_id = :comment_data_source_id" if search_terms.comment_data_source_id.present?

      conditions[:first_name] = "%#{search_terms.first_name}%" if search_terms.first_name.present?
      conditions_string << "first_name ILIKE :first_name" if search_terms.first_name.present?

      conditions[:last_name] = "%#{search_terms.last_name}%" if search_terms.last_name.present?
      conditions_string << "last_name ILIKE :last_name" if search_terms.last_name.present?

      conditions[:email] = "%#{search_terms.email}%" if search_terms.email.present?
      conditions_string << "email ILIKE :email" if search_terms.email.present?

      conditions[:organization] = "%#{search_terms.organization}%" if search_terms.organization.present?
      conditions_string << "organization ILIKE :organization" if search_terms.organization.present?

      conditions[:state] = "%#{search_terms.state}%" if search_terms.state.present?
      conditions_string << "state ILIKE :state" if search_terms.state.present?

      conditions[:comment_text] = "%#{search_terms.comment_text}%" if search_terms.comment_text.present?
      conditions_string << "comment_text ILIKE :comment_text" if search_terms.comment_text.present?

      # filter is for any attachment
      conditions_string << "attachment_url IS NOT NULL AND attachment_url <> ''" if (params[:has_attachment].present? && params[:has_attachment] == "on")

      conditions[:summary] = "%#{search_terms.summary}%" if search_terms.summary.present?
      conditions_string << "comments.summary ILIKE :summary" if search_terms.summary.present?

      #treating specially because of many to many relation
      conditions[:suggested_change_id] = params[:suggested_change_id] if params[:suggested_change_id].present?
      conditions_string << "comments_suggested_changes.suggested_change_id = :suggested_change_id" if params[:suggested_change_id].present?

      conditions[:comment_status_type_id] = search_terms.comment_status_type_id if search_terms.comment_status_type_id.present?
      conditions_string << "comment_status_type_id = :comment_status_type_id" if search_terms.comment_status_type_id.present?

      conditions[:notes] = "%#{search_terms.notes}%" if search_terms.notes.present?
      conditions_string << "comments.notes ILIKE :notes" if search_terms.notes.present?

      #can filter down to manually entered, but if not checked all records returned
      conditions[:manually_entered] = search_terms.manually_entered if search_terms.manually_entered
      conditions_string << "comments.manually_entered = :manually_entered" if search_terms.manually_entered

      return [conditions_string.join(" AND "), conditions]
    end

    def stream_csv(comments)
      set_csv_file_headers('comments.csv')
      set_csv_streaming_headers

      response.status = 200

      write_csv_rows(comments)
    end

    def write_csv_rows(comments)
      begin
        #write out the header row
        response.stream.write CSV.generate_line(Comment.csv_header)

        #write out each row of data
        comments.each do |c|
          response.stream.write CSV.generate_line(c.to_csv)
        end
      ensure
        response.stream.close
      end
    end

end
