class CommentStatusTypesController < ApplicationController
  before_action :admin_user
  before_action :set_comment_status_type, only: [:show, :edit, :update, :destroy]

  # GET /comment_status_types
  # GET /comment_status_types.json
  def index
    @comment_status_types = CommentStatusType.all
  end

  # GET /comment_status_types/1
  # GET /comment_status_types/1.json
  def show
  end

  # GET /comment_status_types/new
  def new
    @comment_status_type = CommentStatusType.new
  end

  # GET /comment_status_types/1/edit
  def edit
  end

  # POST /comment_status_types
  # POST /comment_status_types.json
  def create
    @comment_status_type = CommentStatusType.new(comment_status_type_params)

    respond_to do |format|
      if @comment_status_type.save
        format.html { redirect_to comment_status_types_path, notice: 'Comment status type was successfully created.' }
        format.json { render :show, status: :created, location: @comment_status_type }
      else
        format.html { render :new }
        format.json { render json: @comment_status_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comment_status_types/1
  # PATCH/PUT /comment_status_types/1.json
  def update
    respond_to do |format|
      if @comment_status_type.update(comment_status_type_params)
        format.html { redirect_to comment_status_types_path, notice: 'Comment status type was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment_status_type }
      else
        format.html { render :edit }
        format.json { render json: @comment_status_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comment_status_types/1
  # DELETE /comment_status_types/1.json
  def destroy
    @comment_status_type.destroy
    respond_to do |format|
      format.html { redirect_to comment_status_types_url, notice: 'Comment status type was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment_status_type
      @comment_status_type = CommentStatusType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_status_type_params
      params.require(:comment_status_type).permit(:status_text, :order_in_list)
    end
end
