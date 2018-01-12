class CommentStatusTypesController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user
  before_action :set_comment_status_type, only: [:show, :edit, :update, :destroy]

  # GET /comment_status_types
  # GET /comment_status_types.json
  def index
    @comment_status_types = CommentStatusType.all.order(:order_in_list)
  end

  def move_up
    move(true)
  end

  def move_down
    move(false)
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

    #set the order_in_list
    cst_max = CommentStatusType.maximum(:order_in_list)
    @comment_status_type.order_in_list = cst_max.nil? ? 1 : cst_max + 1

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
    if CommentStatusType.count > 1
      #reassign any comments of this type to the first remaining status type.
      firstCST = CommentStatusType.where.not(id: @comment_status_type.id).order(:order_in_list).first
      reassign_comments(@comment_status_type,firstCST)

      current_CST_num = @comment_status_type.order_in_list
      @comment_status_type.destroy
      handle_delete_of_order_in_list(CommentStatusType,current_CST_num)
      respond_to do |format|
        format.html { redirect_to comment_status_types_url, notice: "Comment status type was successfully deleted. Any comments assigned to this status were reassigned to '#{firstCST.status_text}'." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to comment_status_types_url, error: 'Cannot delete the last comment status type.' }
        format.json { head :no_content }
      end
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

    def move(up = true)
      cst = CommentStatusType.find(params[:id])

      if cst.present?
        cst2 = get_adjacent(cst,up)
        if cst2.present?
          swap_and_save(cst, cst2)
          respond_to do |format|
            format.html { redirect_to comment_status_types_path }
            format.json { head :no_content }
          end
          return
        end
      end
      respond_to do |format|
        format.html { redirect_to comment_status_types_path, notice: "could not move" }
        format.json { render json: @comment_status_type.errors, status: :unprocessable_entity }
      end
    end

    def get_adjacent(current, get_previous = false)
      if get_previous
        CommentStatusType.where("order_in_list < ?",current.order_in_list).order("order_in_list DESC").first
      else
        CommentStatusType.where("order_in_list > ?",current.order_in_list).order(:order_in_list).first
      end
    end

    def reassign_comments(reassign_from_cst, reassign_to_cst)
      Comment.where(comment_status_type_id: reassign_from_cst.id).each do |com|
        com.comment_status_type_id = reassign_to_cst.id
        com.save
      end
    end
end
