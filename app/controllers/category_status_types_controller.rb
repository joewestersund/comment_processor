class CategoryStatusTypesController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user
  before_action :set_category_status_type, only: [:show, :edit, :update, :destroy]

  # GET /category_status_types
  # GET /category_status_types.json
  def index
    @category_status_types = CategoryStatusType.all.order(:order_in_list)
  end

  def move_up
    move(true)
  end

  def move_down
    move(false)
  end

  # GET /category_status_types/1
  # GET /category_status_types/1.json
  def show
  end

  # GET /category_status_types/new
  def new
    @category_status_type = CategoryStatusType.new
  end

  # GET /category_status_types/1/edit
  def edit
  end

  # POST /category_status_types
  # POST /category_status_types.json
  def create
    @category_status_type = CategoryStatusType.new(category_status_type_params)

    #set the order_in_list
    cst_max = CategoryStatusType.maximum(:order_in_list)
    @category_status_type.order_in_list = cst_max.nil? ? 1 : cst_max + 1

    respond_to do |format|
      if @category_status_type.save
        format.html { redirect_to category_status_types_path, notice: 'Category status type was successfully created.' }
        format.json { render :show, status: :created, location: @category_status_type }
      else
        format.html { render :new }
        format.json { render json: @category_status_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /category_status_types/1
  # PATCH/PUT /category_status_types/1.json
  def update
    respond_to do |format|
      if @category_status_type.update(category_status_type_params)
        format.html { redirect_to category_status_types_path, notice: 'Category status type was successfully updated.' }
        format.json { render :show, status: :ok, location: @category_status_type }
      else
        format.html { render :edit }
        format.json { render json: @category_status_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /category_status_types/1
  # DELETE /category_status_types/1.json
  def destroy
    if CategoryStatusType.count > 1
      #reassign any categories of this type to the first remaining status type.
      firstCST = CategoryStatusType.where.not(id: @category_status_type.id).order(:order_in_list).first
      reassign_categories(@category_status_type,firstCST)

      current_CST_num = @category_status_type.order_in_list
      @category_status_type.destroy
      handle_delete_of_order_in_list(CategoryStatusType,current_CST_num)
      respond_to do |format|
        format.html { redirect_to category_status_types_url, notice: "Category status type was successfully deleted. Any categories assigned to this status were reassigned to '#{firstCST.status_text}'." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to category_status_types_url, error: 'Cannot delete the last category status type.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category_status_type
      @category_status_type = CategoryStatusType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_status_type_params
      params.require(:category_status_type).permit(:status_text, :order_in_list)
    end

    def move(up = true)
      cst = CategoryStatusType.find(params[:id])

      if cst.present?
        cst2 = get_adjacent(cst,up)
        if cst2.present?
          swap_and_save(cst, cst2)
          respond_to do |format|
            format.html { redirect_to category_status_types_path }
            format.json { head :no_content }
          end
          return
        end
      end
      respond_to do |format|
        format.html { redirect_to category_status_types_path, notice: "could not move" }
        format.json { render json: @category_status_type.errors, status: :unprocessable_entity }
      end
    end

    def get_adjacent(current, get_previous = false)
      if get_previous
        CategoryStatusType.where("order_in_list < ?",current.order_in_list).order("order_in_list DESC").first
      else
        CategoryStatusType.where("order_in_list > ?",current.order_in_list).order(:order_in_list).first
      end
    end

    def reassign_categories(reassign_from_cst, reassign_to_cst)
      Category.where(category_status_type_id: reassign_from_cst.id).each do |cat|
        cat.category_status_type_id = reassign_to_cst.id
        cat.save
      end
    end
end
