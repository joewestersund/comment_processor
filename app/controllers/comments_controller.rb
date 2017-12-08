class CommentsController < ApplicationController
  include CommentsHelper
  include ActionController::Live
  require 'csv'

  before_action :signed_in_user
  before_action :admin_user, only: [:import, :do_import, :cleanup, :do_cleanup]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_select_options, only: [:new, :edit, :index]

  # GET /comments
  # GET /comments.json
  def index

    conditions = get_conditions
    if conditions[0].empty?
      c = Comment.all
    else
      #do left outer join in case there are no conditions on categories
      c = Comment.where("id IN (?)", Comment.left_outer_joins(:categories).where(conditions).select(:id))
    end
    c = c.order(:id)

    respond_to do |format|
      format.html {
        @total_comments = Comment.count
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

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  def import
    #import comments from the outside data source
    @data_source = rulemaking_data_source
  end

  def do_import
    #actually do the import
    comments_imported = import_comments_data(rulemaking_data_source)
    redirect_to comments_path, notice: "#{comments_imported} comment(s) were successfully imported into the database."
  end

  def cleanup
    #clean up HTML escape characters in the comment text
    @characters_to_clean_up = escape_characters_to_replace
  end

  def do_cleanup
    #actually do the cleanup
    Comment.all.each do |c|
      clean_comment_text(c)
      c.save
    end

    redirect_to comments_path, notice: "HTML escape characters were successfully cleaned from the comment text."
  end

  # GET /comments/1/edit
  def edit
    current_comment_source_id = @comment.source_id

    conditions = get_conditions
    if conditions[0].empty?
      c = Comment.all
    else
      #do left outer join in case there are no conditions on categories
      c = Comment.where("id IN (?)", Comment.left_outer_joins(:categories).where(conditions).select(:id))
    end

    @previous_comment = c.where("source_id < ?", current_comment_source_id).order(:source_id).last
    @next_comment = c.where("source_id > ?", current_comment_source_id).order(:source_id).first

    @filtered = !conditions[0].empty?
    @filter_querystring = remove_empty_elements(filter_params_all)
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update

    respond_to do |format|
      if @comment.update(comment_params) && update_comment_categories
        @filter_querystring = remove_empty_elements(filter_params_all)
        format.html { redirect_to edit_comment_path(@comment,@filter_querystring), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def update_comment_categories
      @categories = Category.where(:id => params[:comment_categories])
      @comment.categories.destroy_all   #disassociate the already added organizers
      @comment.categories << @categories
      true
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:source_id, :first_name, :last_name, :email, :organization, :state, :comment_text, :attachment_url, :summary, :comment_status_type_id, :action_needed)
    end

    def set_select_options
      @users = User.order(:name).all
      @categories = Category.order(:order_in_list).all
      @comment_status_types = CommentStatusType.order(:order_in_list).all
    end

    def filter_params_in_obj
      params.permit(:first_name, :last_name, :email, :organization, :state, :comment_text, :summary, :comment_status_type_id, :action_needed, :manually_entered)
    end

    def filter_params_all
      params.permit(:first_name, :last_name, :email, :organization, :state, :comment_text, :summary, :comment_status_type_id, :action_needed, :manually_entered, :has_attachment, :category_id, )
    end

    def get_conditions

      search_terms = Comment.new(filter_params_in_obj)

      conditions = {}
      conditions_string = []

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
      conditions_string << "attachment_url IS NOT NULL" if (params[:has_attachment].present? && params[:has_attachment] == "on")

      conditions[:summary] = "%#{search_terms.summary}%" if search_terms.summary.present?
      conditions_string << "comments.summary ILIKE :summary" if search_terms.summary.present?

      #treating specially because of many to many relation
      conditions[:category_id] = params[:category_id] if params[:category_id].present?
      conditions_string << "categories_comments.category_id = :category_id" if params[:category_id].present?

      conditions[:comment_status_type_id] = search_terms.comment_status_type_id if search_terms.comment_status_type_id.present?
      conditions_string << "comment_status_type_id = :comment_status_type_id" if search_terms.comment_status_type_id.present?

      conditions[:action_needed] = "%#{search_terms.action_needed}%" if search_terms.action_needed.present?
      conditions_string << "comments.action_needed ILIKE :action_needed" if search_terms.action_needed.present?

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
