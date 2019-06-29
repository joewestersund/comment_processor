class SuggestedChangesController < ApplicationController
  include ChangeLogEntriesHelper
  include ActionController::Live
  require 'csv'

  before_action :signed_in_user
  before_action :not_read_only_user, only: [:new, :edit, :create, :update, :destroy, :move_up, :move_down]
  before_action :admin_user, only: [:renumber, :do_renumber, :merge, :merge_preview, :do_merge, :copy, :do_copy]
  before_action :set_suggested_change, only: [:show, :edit, :update, :destroy, :do_merge]
  before_action :set_select_options, only: [:new, :edit, :index, :merge_preview]

  # GET /suggested_changes
  # GET /suggested_changes.json
  def index
    conditions = get_conditions
    if conditions[0].empty?
      c = current_rulemaking.suggested_changes.all
    else
      c = current_rulemaking.suggested_changes.where(conditions)
    end

    respond_to do |format|
      format.html {
        @total_suggested_changes = current_rulemaking.suggested_changes.all.count
        @filtered = !conditions[0].empty?
        @filter_querystring = remove_empty_elements(filter_params)

        c = c.order(Arel.sql('LOWER(suggested_change_name)'))
        @suggested_changes = c.page(params[:page]).per_page(10)
      }
      format.xlsx {
        c = c.order(:order_in_list)
        @suggested_changes = c
        response.headers['Content-Disposition'] = 'attachment; filename="suggested_changes.xlsx"'
      }
      format.csv {
        c = c.order(:order_in_list)
        stream_csv(c)
      }
    end
  end

  def move_up
    move(true)
  end

  def move_down
    move(false)
  end

  def renumber

  end

  def do_renumber
    #actually do the renumbering
    #since there's a uniqueness and >0 validation, first move them all up
    max_order_in_list = current_rulemaking.suggested_changes.maximum(:order_in_list)
    current_rulemaking.suggested_changes.all.each do |cat|
      cat.order_in_list += max_order_in_list
      cat.save
    end

    #now renumber them starting from 1
    order_number = 1
    current_rulemaking.suggested_changes.order(Arel.sql('LOWER(suggested_change_name)')).each do |cat|
      cat.order_in_list = order_number
      cat.save
      order_number += 1
    end

    save_change_log(current_user,{object_type: 'suggested_change', action_type: 'renumber', description: "ran the renumber process to make order_in_list match up with alphabetical order by suggested_change_name."})
    redirect_to suggested_changes_path, notice: "The suggested changes' order_in_list were successfully renumbered to match their alphabetical order by order_in_list."
  end

  def copy
    @suggested_changes = current_rulemaking.suggested_changes.order(Arel.sql('LOWER(suggested_change_name)')).all
  end

  def do_copy
    if params[:suggested_change_id].nil?
      redirect_to suggested_change_copy_path, alert: 'Error: must select which suggested change to copy.'
    end

    existing_suggested_change = current_rulemaking.suggested_changes.find(params[:suggested_change_id])

    @suggested_change = existing_suggested_change.duplicate
    @suggested_change.suggested_change_name = "Copy of #{existing_suggested_change.suggested_change_name}"
    @suggested_change.assigned_to_id = current_user.id

    #set the order_in_list
    c_max = current_rulemaking.suggested_changes.maximum(:order_in_list)
    @suggested_change.order_in_list = c_max.nil? ? 1 : c_max + 1

    if @suggested_change.save
      save_change_log(current_user,{suggested_change: @suggested_change, action_type: 'create copy'})
      redirect_to edit_suggested_change_path(@suggested_change), notice: "Suggested change was successfully copied"
    else
      @suggested_changes = current_rulemaking.suggested_changes.order(Arel.sql('LOWER(suggested_change_name)')).all
      render :copy
    end

  end

  def merge
    @suggested_changes = current_rulemaking.suggested_changes.order(Arel.sql('LOWER(suggested_change_name)')).all
  end

  def merge_preview
    if params[:from_suggested_change_id].empty? || params[:to_suggested_change_id].empty?
      redirect_to suggested_changes_merge_path, alert: 'Error: must select a suggested_change to copy from, and one to copy into.'
    elsif params[:from_suggested_change_id] == params[:to_suggested_change_id]
      redirect_to suggested_changes_merge_path, alert: "Error: the 'from' suggested_change must be different from the 'to' suggested_change."
    else
      @from_suggested_change = current_rulemaking.suggested_changes.find(params[:from_suggested_change_id])
      @to_suggested_change = current_rulemaking.suggested_changes.find(params[:to_suggested_change_id])
      @preview_of_merged_suggested_change = @to_suggested_change.preview_merge(@from_suggested_change)
      @preview_of_merged_suggested_change.id = @to_suggested_change.id #so that when it's saved, it will save over @to_suggested_change.

      comments_only_in_from_suggested_change = (@preview_of_merged_suggested_change.comments - @to_suggested_change.comments)
      comments_only_in_to_suggested_change = (@preview_of_merged_suggested_change.comments - @from_suggested_change.comments)
      comments_in_both_suggested_changes = (@preview_of_merged_suggested_change.comments - comments_only_in_from_suggested_change - comments_only_in_to_suggested_change)

      @comment_source = [{source: "only in 'from' suggested_change", comment_count: comments_only_in_from_suggested_change.count},
                         {source: "only in 'to' suggested_change", comment_count: comments_only_in_to_suggested_change.count},
                         {source: "in both suggested_changes", comment_count: comments_in_both_suggested_changes.count}]

    end
  end

  def do_merge
    from_suggested_change = current_rulemaking.suggested_changes.find(params[:from_suggested_change_id])
    respond_to do |format|
      if @suggested_change.update(suggested_change_params)
        @suggested_change.comments << (from_suggested_change.comments - @suggested_change.comments)
        save_change_log(current_user,{suggested_change: @suggested_change, action_type: 'update via merge'})
        destroy_suggested_change(from_suggested_change, {action_type: 'delete via merge'})
        format.html { redirect_to edit_suggested_change_path(@suggested_change), notice: "The suggested changes were successfully merged." }
      else
        format.html { render :merge }
      end
    end
  end

  # GET /suggested_changes/new
  def new
    @suggested_change = SuggestedChange.new
    #by default, assign to whoever created it
    @suggested_change.assigned_to_id = current_user.id
    @suggested_change.rulemaking = current_rulemaking
    @suggested_change.suggested_change_status_type = current_rulemaking.suggested_change_status_types.first
  end

  # GET /suggested_changes/1
  # GET /suggested_changes/1.json
  def show
    get_filtering_and_next_and_previous
    @change_log_entries = current_rulemaking.change_log_entries.where(suggested_change: @suggested_change).order(created_at: :desc).page(params[:page]).per_page(10)
  end

  # GET /suggested_changes/1/edit
  def edit
    get_filtering_and_next_and_previous
    @change_log_entries = current_rulemaking.change_log_entries.where(suggested_change: @suggested_change).order(created_at: :desc).page(params[:page]).per_page(10)
  end

  # POST /suggested_changes
  # POST /suggested_changes.json
  def create
    @suggested_change = SuggestedChange.new(suggested_change_params)
    @suggested_change.rulemaking = current_rulemaking

    #set the order_in_list
    c_max = current_rulemaking.suggested_changes.maximum(:order_in_list)
    @suggested_change.order_in_list = c_max.nil? ? 1 : c_max + 1

    email_sent_text = ""

    respond_to do |format|
      if @suggested_change.save
        save_change_log(current_user,{suggested_change: @suggested_change, action_type: 'create'})
        if @suggested_change.assigned_to_id.present? && @suggested_change.assigned_to_id != current_user.id
          NotificationMailer.suggested_change_assigned_email(@suggested_change,current_user,false).deliver
          email_sent_text = " An email was sent to #{@suggested_change.assigned_to.name} to let them know this suggested_change is assigned to them."
        end
        format.html { redirect_to edit_suggested_change_path(@suggested_change), notice: "Suggested change was successfully created.#{email_sent_text}" }
      else
        set_select_options
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /suggested_changes/1
  # PATCH/PUT /suggested_changes/1.json
  def update
    email_sent_text = ""
    previous_assigned_to_id = @suggested_change.assigned_to_id
    respond_to do |format|
      if @suggested_change.update(suggested_change_params)
        save_change_log(current_user,{suggested_change: @suggested_change, action_type: 'edit'})
        if @suggested_change.assigned_to_id.present? && @suggested_change.assigned_to_id != current_user.id && @suggested_change.assigned_to_id != previous_assigned_to_id
          NotificationMailer.suggested_change_assigned_email(@suggested_change,current_user,false).deliver
          email_sent_text = " An email was sent to #{@suggested_change.assigned_to.name} to let them know this suggested_change is assigned to them."
        end
        @filter_querystring = remove_empty_elements(filter_params)
        format.html { redirect_to edit_suggested_change_path(@suggested_change,@filter_querystring), notice: "Suggested change was successfully updated.#{email_sent_text}" }
      else
        set_select_options
        format.html { render :edit }
      end
    end
  end

  # DELETE /suggested_changes/1
  # DELETE /suggested_changes/1.json
  def destroy
    destroy_suggested_change(@suggested_change)
    respond_to do |format|
      format.html { redirect_to suggested_changes_url, notice: 'Suggested change was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    def destroy_suggested_change(suggested_change, options = {})
      current_cat_num = suggested_change.order_in_list
      #note: can't associate this change log entry with the suggested_change object, because the suggested_change is about to be destroyed.
      action_type = options[:action_type] || "delete"
      save_change_log(current_user,{object_type: 'suggested_change', action_type: action_type, description: "deleted suggested_change ID ##{suggested_change.order_in_list}, '#{suggested_change.suggested_change_name}', #{suggested_change.as_json}"})
      suggested_change.destroy
      handle_delete_of_order_in_list(current_rulemaking.suggested_changes,current_cat_num)
    end

    def get_filtering_and_next_and_previous

      current_suggested_change_suggested_change_name = @suggested_change.suggested_change_name.downcase

      conditions = get_conditions
      if conditions[0].empty?
        c = current_rulemaking.suggested_changes.all
      else
        c = current_rulemaking.suggested_changes.where(conditions)
      end

      @previous_suggested_change = c.where("LOWER(suggested_change_name) < ?", current_suggested_change_suggested_change_name).order(Arel.sql("LOWER(suggested_change_name)")).last
      @next_suggested_change = c.where("LOWER(suggested_change_name) > ?", current_suggested_change_suggested_change_name).order(Arel.sql("LOWER(suggested_change_name)")).first

      @filtered = !conditions[0].empty?
      @filter_querystring = remove_empty_elements(filter_params)
    end

    def set_suggested_change
      @suggested_change = current_rulemaking.suggested_changes.find_by(id: params[:id])
      if @suggested_change.nil?
        respond_to do |format|
          format.html { redirect_to suggested_changes_url, alert: "SuggestedChange #{params[:id]} was not found." }
          format.json { head :no_content }
        end
      end
    end

    def set_select_options
      @users = User.includes(:user_permissions).where('user_permissions.rulemaking_id' => current_rulemaking.id).order(:name).all
      @suggested_change_status_types = current_rulemaking.suggested_change_status_types.order(:order_in_list).all
      @suggested_change_response_types = current_rulemaking.suggested_change_response_types.order(:order_in_list).all
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def suggested_change_params
      params.require(:suggested_change).permit(:suggested_change_name, :description, :response_text, :assigned_to_id, :suggested_change_status_type_id, :suggested_change_response_type_id ,:action_needed, :rule_change_made, :order_in_list, :notes, :text_from_comments)
    end

    def filter_params
      params.permit(:suggested_change_name, :description, :response_text, :assigned_to_id, :suggested_change_status_type_id, :suggested_change_response_type_id, :action_needed, :rule_change_made, :notes, :text_from_comments)
    end

    def get_conditions

        search_terms = SuggestedChange.new(filter_params)

        conditions = {}
        conditions_string = []

        conditions[:suggested_change_name] = "%#{search_terms.suggested_change_name}%" if search_terms.suggested_change_name.present?
        conditions_string << "suggested_change_name ILIKE :suggested_change_name" if search_terms.suggested_change_name.present?

        conditions[:text_from_comments] = "%#{search_terms.text_from_comments}%" if search_terms.text_from_comments.present?
        conditions_string << "text_from_comments ILIKE :text_from_comments" if search_terms.text_from_comments.present?

        conditions[:description] = "%#{search_terms.description}%" if search_terms.description.present?
        conditions_string << "description ILIKE :description" if search_terms.description.present?

        conditions[:response_text] = "%#{search_terms.response_text}%" if search_terms.response_text.present?
        conditions_string << "response_text ILIKE :response_text" if search_terms.response_text.present?

        conditions[:assigned_to_id] = search_terms.assigned_to_id if search_terms.assigned_to_id.present?
        conditions_string << "assigned_to_id = :assigned_to_id" if search_terms.assigned_to_id.present?

        conditions[:suggested_change_status_type_id] = search_terms.suggested_change_status_type_id if search_terms.suggested_change_status_type_id.present?
        conditions_string << "suggested_change_status_type_id = :suggested_change_status_type_id" if search_terms.suggested_change_status_type_id.present?

        conditions[:suggested_change_response_type_id] = search_terms.suggested_change_response_type_id if search_terms.suggested_change_response_type_id.present?
        conditions_string << "suggested_change_response_type_id = :suggested_change_response_type_id" if search_terms.suggested_change_response_type_id.present?

        #can filter down to rule_change_made, but if not checked all records returned
        conditions[:rule_change_made] = search_terms.rule_change_made if search_terms.rule_change_made
        conditions_string << "rule_change_made = :rule_change_made" if search_terms.rule_change_made

        conditions[:action_needed] = "%#{search_terms.action_needed}%" if search_terms.action_needed.present?
        conditions_string << "action_needed ILIKE :action_needed" if search_terms.action_needed.present?

        conditions[:notes] = "%#{search_terms.notes}%" if search_terms.notes.present?
        conditions_string << "notes ILIKE :notes" if search_terms.notes.present?

        #no filter on order_in_list.

        return [conditions_string.join(" AND "), conditions]
      end

    def move(up = true)
      c = current_rulemaking.suggested_changes.find(params[:id])

      if c.present?
        c2 = get_adjacent(c,up)
        if c2.present?
          swap_and_save(c, c2)
          respond_to do |format|
            format.html { redirect_to suggested_changes_path }
            format.json { head :no_content }
          end
          return
        end
      end
      respond_to do |format|
        format.html { redirect_to suggested_changes_path, notice: "could not move" }
        format.json { render json: @suggested_change.errors, status: :unprocessable_entity }
      end
    end

    def get_adjacent(current, get_previous = false)
      if get_previous
        current_rulemaking.suggested_changes.where("order_in_list < ?",current.order_in_list).order("order_in_list DESC").first
      else
        current_rulemaking.suggested_changes.where("order_in_list > ?",current.order_in_list).order(:order_in_list).first
      end
    end

    def stream_csv(suggested_changes)
      set_csv_file_headers('suggested_changes.csv')
      set_csv_streaming_headers

      response.status = 200

      write_csv_rows(suggested_changes)
    end

    def write_csv_rows(suggested_changes)
      begin
        #write out the header row
        response.stream.write CSV.generate_line(SuggestedChange.csv_header)

        #write out each row of data
        suggested_changes.each do |cat|
          response.stream.write CSV.generate_line(cat.to_csv)
        end
      ensure
        response.stream.close
      end
    end
end
