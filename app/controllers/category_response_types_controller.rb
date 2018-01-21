class CategoryResponseTypesController < ApplicationController
  include ChangeLogEntriesHelper

  before_action :signed_in_user
  before_action :admin_user
  before_action :not_read_only_user, only: [:new, :edit, :create, :update, :destroy, :move_up, :move_down]
  before_action :set_category_response_type, only: [:show, :edit, :update, :destroy]

  # GET /category_response_types
  # GET /category_response_types.json
  def index
    @category_response_types = CategoryResponseType.order(:order_in_list).all
  end

  # GET /category_response_types/1
  # GET /category_response_types/1.json
  def show
  end

  def move_up
    move(true)
  end

  def move_down
    move(false)
  end

  # GET /category_response_types/new
  def new
    @category_response_type = CategoryResponseType.new
  end

  # GET /category_response_types/1/edit
  def edit
  end

  # POST /category_response_types
  # POST /category_response_types.json
  def create
    @category_response_type = CategoryResponseType.new(category_response_type_params)

    #set the order_in_list
    crt_max = CategoryResponseType.maximum(:order_in_list)
    @category_response_type.order_in_list = crt_max.nil? ? 1 : crt_max + 1

    respond_to do |format|
      if @category_response_type.save
        save_change_log(current_user,{object_type: 'category response type', action_type: 'create', description: "added category response type ID ##{@category_response_type.id} '#{@category_response_type.response_text}'"})
        format.html { redirect_to category_response_types_path, notice: 'Category response type was successfully created.' }
        format.json { render :show, status: :created, location: @category_response_type }
      else
        format.html { render :new }
        format.json { render json: @category_response_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /category_response_types/1
  # PATCH/PUT /category_response_types/1.json
  def update
    respond_to do |format|
      if @category_response_type.update(category_response_type_params)
        if @category_response_type.previous_changes.any?
          save_change_log(current_user,{object_type: 'category response type', action_type: 'edit', description: "edited category response type ID ##{@category_response_type.id} to '#{@category_response_type.response_text}'"})
        end
        format.html { redirect_to category_response_types_path, notice: 'Category response type was successfully updated.' }
        format.json { render :show, status: :ok, location: @category_response_type }
      else
        format.html { render :edit }
        format.json { render json: @category_response_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /category_response_types/1
  # DELETE /category_response_types/1.json
  def destroy
    save_change_log(current_user,{object_type: 'category response type', action_type: 'delete', description: "deleted category response type ID ##{@category_response_type.id} '#{@category_response_type.response_text}'"})
    #any categories assigned to this response type will be set to null automatically by the foreign key constraint.
    current_CRT_num = @category_response_type.order_in_list
    @category_response_type.destroy
    handle_delete_of_order_in_list(CategoryResponseType,current_CRT_num)
    respond_to do |format|
      format.html { redirect_to category_response_types_url, notice: 'Category response type was successfully destroyed. Any categories assigned to this response type have been set to response = nil.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category_response_type
      @category_response_type = CategoryResponseType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_response_type_params
      params.require(:category_response_type).permit(:response_text, :order_in_list)
    end

    def move(up = true)
      crt = CategoryResponseType.find(params[:id])

      if crt.present?
        crt2 = get_adjacent(crt,up)
        if crt2.present?
          swap_and_save(crt, crt2)
          respond_to do |format|
            format.html { redirect_to category_response_types_path }
            format.json { head :no_content }
          end
          return
        end
      end
      respond_to do |format|
        format.html { redirect_to category_response_types_path, notice: "could not move" }
        format.json { render json: @category_response_type.errors, status: :unprocessable_entity }
      end
    end

    def get_adjacent(current, get_previous = false)
      if get_previous
        CategoryResponseType.where("order_in_list < ?",current.order_in_list).order("order_in_list DESC").first
      else
        CategoryResponseType.where("order_in_list > ?",current.order_in_list).order(:order_in_list).first
      end
    end

end
