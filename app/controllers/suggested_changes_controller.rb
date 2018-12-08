class CategoriesController < ApplicationController
  include ChangeLogEntriesHelper
  include ActionController::Live
  require 'csv'

  before_action :signed_in_user
  before_action :not_read_only_user, only: [:new, :edit, :create, :update, :destroy, :move_up, :move_down]
  before_action :admin_user, only: [:renumber, :do_renumber, :merge, :merge_preview, :do_merge, :copy, :do_copy]
  before_action :set_category, only: [:show, :edit, :update, :destroy, :do_merge]
  before_action :set_select_options, only: [:new, :edit, :index, :merge_preview]

  # GET /categories
  # GET /categories.json
  def index
    conditions = get_conditions
    if conditions[0].empty?
      c = current_rulemaking.categories.all
    else
      c = current_rulemaking.categories.where(conditions)
    end

    respond_to do |format|
      format.html {
        @total_categories = current_rulemaking.categories.all.count
        @filtered = !conditions[0].empty?
        @filter_querystring = remove_empty_elements(filter_params)

        c = c.order('LOWER(category_name)')
        @categories = c.page(params[:page]).per_page(10)
      }
      format.xlsx {
        c = c.order(:order_in_list)
        @categories = c
        response.headers['Content-Disposition'] = 'attachment; filename="categories.xlsx"'
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
    max_order_in_list = current_rulemaking.categories.maximum(:order_in_list)
    current_rulemaking.categories.all.each do |cat|
      cat.order_in_list += max_order_in_list
      cat.save
    end

    #now renumber them starting from 1
    order_number = 1
    current_rulemaking.categories.order('LOWER(category_name)').each do |cat|
      cat.order_in_list = order_number
      cat.save
      order_number += 1
    end

    save_change_log(current_user,{object_type: 'category', action_type: 'renumber', description: "ran the renumber process to make order_in_list match up with alphabetical order by category_name."})
    redirect_to categories_path, notice: "The categories' order_in_list were successfully renumbered to match their alphabetical order by order_in_list."
  end

  def copy
    @categories = current_rulemaking.categories.order('LOWER(category_name)').all
  end

  def do_copy
    if params[:category_id].nil?
      redirect_to category_copy_path, alert: 'Error: must select which category to copy.'
    end

    existing_category = current_rulemaking.categories.find(params[:category_id])

    @category = existing_category.duplicate
    @category.category_name = "Copy of #{existing_category.category_name}"
    @category.assigned_to_id = current_user.id

    #set the order_in_list
    c_max = current_rulemaking.categories.maximum(:order_in_list)
    @category.order_in_list = c_max.nil? ? 1 : c_max + 1

    if @category.save
      save_change_log(current_user,{category: @category, action_type: 'create copy'})
      redirect_to edit_category_path(@category), notice: "Category was successfully copied"
    else
      @categories = current_rulemaking.categories.order('LOWER(category_name)').all
      render :copy
    end

  end

  def merge
    @categories = current_rulemaking.categories.order('LOWER(category_name)').all
  end

  def merge_preview
    if params[:from_category_id].empty? || params[:to_category_id].empty?
      redirect_to categories_merge_path, alert: 'Error: must select a category to copy from, and one to copy into.'
    elsif params[:from_category_id] == params[:to_category_id]
      redirect_to categories_merge_path, alert: "Error: the 'from' category must be different from the 'to' category."
    else
      @from_category = current_rulemaking.categories.find(params[:from_category_id])
      @to_category = current_rulemaking.categories.find(params[:to_category_id])
      @preview_of_merged_category = @to_category.preview_merge(@from_category)
      @preview_of_merged_category.id = @to_category.id #so that when it's saved, it will save over @to_category.

      comments_only_in_from_category = (@preview_of_merged_category.comments - @to_category.comments)
      comments_only_in_to_category = (@preview_of_merged_category.comments - @from_category.comments)
      comments_in_both_categories = (@preview_of_merged_category.comments - comments_only_in_from_category - comments_only_in_to_category)

      @comment_source = [{source: "only in 'from' category", comment_count: comments_only_in_from_category.count},
                         {source: "only in 'to' category", comment_count: comments_only_in_to_category.count},
                         {source: "in both categories", comment_count: comments_in_both_categories.count}]

    end
  end

  def do_merge
    from_category = current_rulemaking.categories.find(params[:from_category_id])
    respond_to do |format|
      if @category.update(category_params)
        @category.comments << (from_category.comments - @category.comments)
        save_change_log(current_user,{category: @category, action_type: 'update via merge'})
        destroy_category(from_category, {action_type: 'delete via merge'})
        format.html { redirect_to edit_category_path(@category), notice: "Categories were successfully merged." }
      else
        format.html { render :merge }
      end
    end
  end

  # GET /categories/new
  def new
    @category = Category.new
    #by default, assign to whoever created it
    @category.assigned_to_id = current_user.id
    @category.rulemaking = current_rulemaking
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    get_filtering_and_next_and_previous
    @change_log_entries = current_rulemaking.change_log_entries.where(category: @category).order(created_at: :desc).page(params[:page]).per_page(10)
  end

  # GET /categories/1/edit
  def edit
    get_filtering_and_next_and_previous
    @change_log_entries = current_rulemaking.change_log_entries.where(category: @category).order(created_at: :desc).page(params[:page]).per_page(10)
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)
    @category.rulemaking = current_rulemaking

    #set the order_in_list
    c_max = current_rulemaking.categories.maximum(:order_in_list)
    @category.order_in_list = c_max.nil? ? 1 : c_max + 1

    email_sent_text = ""

    respond_to do |format|
      if @category.save
        save_change_log(current_user,{category: @category, action_type: 'create'})
        if @category.assigned_to_id.present? && @category.assigned_to_id != current_user.id
          NotificationMailer.category_assigned_email(@category,current_user,false).deliver
          email_sent_text = " An email was sent to #{@category.assigned_to.name} to let them know this category is assigned to them."
        end
        format.html { redirect_to edit_category_path(@category), notice: "Category was successfully created.#{email_sent_text}" }
      else
        set_select_options
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    email_sent_text = ""
    previous_assigned_to_id = @category.assigned_to_id
    respond_to do |format|
      if @category.update(category_params)
        save_change_log(current_user,{category: @category, action_type: 'edit'})
        if @category.assigned_to_id.present? && @category.assigned_to_id != current_user.id && @category.assigned_to_id != previous_assigned_to_id
          NotificationMailer.category_assigned_email(@category,current_user,false).deliver
          email_sent_text = " An email was sent to #{@category.assigned_to.name} to let them know this category is assigned to them."
        end
        @filter_querystring = remove_empty_elements(filter_params)
        format.html { redirect_to edit_category_path(@category,@filter_querystring), notice: "Category was successfully updated.#{email_sent_text}" }
      else
        set_select_options
        format.html { render :edit }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    destroy_category(@category)
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    def destroy_category(category, options = {})
      current_cat_num = category.order_in_list
      #note: can't associate this change log entry with the category object, because the category is about to be destroyed.
      action_type = options[:action_type] || "delete"
      save_change_log(current_user,{object_type: 'category', action_type: action_type, description: "deleted category ID ##{category.order_in_list}, '#{category.category_name}', #{category.as_json}"})
      category.destroy
      handle_delete_of_order_in_list(current_rulemaking.categories,current_cat_num)
    end

    def get_filtering_and_next_and_previous

      current_category_category_name = @category.category_name.downcase

      conditions = get_conditions
      if conditions[0].empty?
        c = current_rulemaking.categories.all
      else
        c = current_rulemaking.categories.where(conditions)
      end

      @previous_category = c.where("LOWER(category_name) < ?", current_category_category_name).order("LOWER(category_name)").last
      @next_category = c.where("LOWER(category_name) > ?", current_category_category_name).order("LOWER(category_name)").first

      @filtered = !conditions[0].empty?
      @filter_querystring = remove_empty_elements(filter_params)
    end

    def set_category
      @category = current_rulemaking.categories.find_by(id: params[:id])
      if @category.nil?
        respond_to do |format|
          format.html { redirect_to categories_url, alert: "Category #{params[:id]} was not found." }
          format.json { head :no_content }
        end
      end
    end

    def set_select_options
      @users = User.includes(:user_permissions).where('user_permissions.rulemaking_id' => current_rulemaking.id).order(:name).all
      @category_status_types = current_rulemaking.category_status_types.order(:order_in_list).all
      @category_response_types = current_rulemaking.category_response_types.order(:order_in_list).all
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:category_name, :description, :response_text, :assigned_to_id, :category_status_type_id, :category_response_type_id ,:action_needed, :rule_change_made, :order_in_list, :notes, :text_from_comments)
    end

    def filter_params
      params.permit(:category_name, :description, :response_text, :assigned_to_id, :category_status_type_id, :category_response_type_id, :action_needed, :rule_change_made, :notes, :text_from_comments)
    end

    def get_conditions

        search_terms = Category.new(filter_params)

        conditions = {}
        conditions_string = []

        conditions[:category_name] = "%#{search_terms.category_name}%" if search_terms.category_name.present?
        conditions_string << "category_name ILIKE :category_name" if search_terms.category_name.present?

        conditions[:text_from_comments] = "%#{search_terms.text_from_comments}%" if search_terms.text_from_comments.present?
        conditions_string << "text_from_comments ILIKE :text_from_comments" if search_terms.text_from_comments.present?

        conditions[:description] = "%#{search_terms.description}%" if search_terms.description.present?
        conditions_string << "description ILIKE :description" if search_terms.description.present?

        conditions[:response_text] = "%#{search_terms.response_text}%" if search_terms.response_text.present?
        conditions_string << "response_text ILIKE :response_text" if search_terms.response_text.present?

        conditions[:assigned_to_id] = search_terms.assigned_to_id if search_terms.assigned_to_id.present?
        conditions_string << "assigned_to_id = :assigned_to_id" if search_terms.assigned_to_id.present?

        conditions[:category_status_type_id] = search_terms.category_status_type_id if search_terms.category_status_type_id.present?
        conditions_string << "category_status_type_id = :category_status_type_id" if search_terms.category_status_type_id.present?

        conditions[:category_response_type_id] = search_terms.category_response_type_id if search_terms.category_response_type_id.present?
        conditions_string << "category_response_type_id = :category_response_type_id" if search_terms.category_response_type_id.present?

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
      c = current_rulemaking.categories.find(params[:id])

      if c.present?
        c2 = get_adjacent(c,up)
        if c2.present?
          swap_and_save(c, c2)
          respond_to do |format|
            format.html { redirect_to categories_path }
            format.json { head :no_content }
          end
          return
        end
      end
      respond_to do |format|
        format.html { redirect_to categories_path, notice: "could not move" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end

    def get_adjacent(current, get_previous = false)
      if get_previous
        current_rulemaking.categories.where("order_in_list < ?",current.order_in_list).order("order_in_list DESC").first
      else
        current_rulemaking.categories.where("order_in_list > ?",current.order_in_list).order(:order_in_list).first
      end
    end

    def stream_csv(categories)
      set_csv_file_headers('categories.csv')
      set_csv_streaming_headers

      response.status = 200

      write_csv_rows(categories)
    end

    def write_csv_rows(categories)
      begin
        #write out the header row
        response.stream.write CSV.generate_line(Category.csv_header)

        #write out each row of data
        categories.each do |cat|
          response.stream.write CSV.generate_line(cat.to_csv)
        end
      ensure
        response.stream.close
      end
    end
end