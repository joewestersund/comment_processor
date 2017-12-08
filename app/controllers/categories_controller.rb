class CategoriesController < ApplicationController
  include ActionController::Live
  require 'csv'

  before_action :signed_in_user
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :set_select_options, only: [:new, :edit, :index]

  # GET /categories
  # GET /categories.json
  def index
    conditions = get_conditions
    if conditions[0].empty?
      c = Category.all
    else
      c = Category.where(conditions)
    end
    c = c.order(:order_in_list)

    respond_to do |format|
      format.html {
        @total_categories = Category.all.count
        @filtered = !conditions[0].empty?
        @filter_querystring = remove_empty_elements(filter_params)
        @categories = c.page(params[:page]).per_page(10)
      }
      format.xlsx {
        @categories = c
        response.headers['Content-Disposition'] = 'attachment; filename="categories.xlsx"'
      }
      format.csv {
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

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
    #by default, assign to whoever created it
    @category.assigned_to = current_user.id
  end

  # GET /categories/1/edit
  def edit
    current_category_order_in_list = @category.order_in_list

    conditions = get_conditions
    if conditions[0].empty?
      c = Category.all
    else
      c = Category.where(conditions)
    end

    @previous_category = c.where("order_in_list < ?", current_category_order_in_list).order(:order_in_list).last
    @next_category = c.where("order_in_list > ?", current_category_order_in_list).order(:order_in_list).first

    @filtered = !conditions[0].empty?
    @filter_querystring = remove_empty_elements(filter_params)
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    #set the order_in_list
    c_max = Category.maximum(:order_in_list)
    @category.order_in_list = c_max.nil? ? 1 : c_max + 1

    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'Category was successfully created.' }
      else
        set_select_options
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        @filter_querystring = remove_empty_elements(filter_params)
        format.html { redirect_to edit_category_path(@category,@filter_querystring), notice: 'Category was successfully updated.' }
      else
        set_select_options
        format.html { render :edit }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    current_cat = @category.order_in_list
    @category.destroy
    Category.where("order_in_list > ?",current_cat).order(:order_in_list).each do |cat|
      cat.order_in_list -= 1
      cat.save
    end

    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    def set_select_options
      @users = User.order(:name).all
      @category_status_types = CategoryStatusType.order(:order_in_list).all
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:category_name, :summary, :response_text, :assigned_to, :category_status_type_id, :action_needed, :order_in_list)
    end

    def filter_params
      params.permit(:category_name, :summary, :response_text, :assigned_to, :category_status_type_id, :action_needed)
    end

    def get_conditions

        search_terms = Category.new(filter_params)

        conditions = {}
        conditions_string = []

        conditions[:category_name] = "%#{search_terms.category_name}%" if search_terms.category_name.present?
        conditions_string << "category_name ILIKE :category_name" if search_terms.category_name.present?

        conditions[:summary] = "%#{search_terms.summary}%" if search_terms.summary.present?
        conditions_string << "summary ILIKE :summary" if search_terms.summary.present?

        conditions[:response_text] = "%#{search_terms.response_text}%" if search_terms.response_text.present?
        conditions_string << "response_text ILIKE :response_text" if search_terms.response_text.present?

        conditions[:assigned_to] = search_terms.assigned_to if search_terms.assigned_to.present?
        conditions_string << "assigned_to = :assigned_to" if search_terms.assigned_to.present?

        conditions[:category_status_type_id] = search_terms.category_status_type_id if search_terms.category_status_type_id.present?
        conditions_string << "category_status_type_id = :category_status_type_id" if search_terms.category_status_type_id.present?

        conditions[:action_needed] = "%#{search_terms.action_needed}%" if search_terms.action_needed.present?
        conditions_string << "comments.action_needed ILIKE :action_needed" if search_terms.action_needed.present?

        #no filter on order_in_list.

        return [conditions_string.join(" AND "), conditions]
      end

    def move(up = true)
      c = Category.find(params[:id])

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
        Category.where("order_in_list < ?",current.order_in_list).order("order_in_list DESC").first
      else
        Category.where("order_in_list > ?",current.order_in_list).order(:order_in_list).first
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
