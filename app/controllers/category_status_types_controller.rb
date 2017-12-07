class CategoryStatusTypesController < ApplicationController
  before_action :admin_user
  before_action :set_category_status_type, only: [:show, :edit, :update, :destroy]

  # GET /category_status_types
  # GET /category_status_types.json
  def index
    @category_status_types = CategoryStatusType.all
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
    @category_status_type.destroy
    respond_to do |format|
      format.html { redirect_to category_status_types_url, notice: 'Category status type was successfully deleted.' }
      format.json { head :no_content }
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
end
