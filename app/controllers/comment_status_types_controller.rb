class CommentStatusTypesController < ApplicationController
  include ChangeLogEntriesHelper
  include ColorHelper

  before_action :signed_in_user
  before_action :admin_user
  before_action :not_read_only_user, only: [:new, :edit, :create, :update, :destroy, :move_up, :move_down]
  before_action :set_comment_status_type, only: [:show, :edit, :update, :destroy]
  before_action :set_select_options, only: [:new, :edit]

  # GET /comment_status_types
  # GET /comment_status_types.json
  def index
    @comment_status_types = current_rulemaking.comment_status_types.order(:order_in_list)
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
    @comment_status_type.rulemaking = current_rulemaking
  end

  # GET /comment_status_types/1/edit
  def edit
  end

  # POST /comment_status_types
  # POST /comment_status_types.json
  def create
    @comment_status_type = CommentStatusType.new(comment_status_type_params)
    @comment_status_type.rulemaking = current_rulemaking

    #set the order_in_list
    cst_max = current_rulemaking.comment_status_types.maximum(:order_in_list)
    @comment_status_type.order_in_list = cst_max.nil? ? 1 : cst_max + 1

    respond_to do |format|
      if @comment_status_type.save
        save_change_log(current_user,{object_type: 'comment status type', action_type: 'create', description: "created comment status type ID ##{@comment_status_type.id} '#{@comment_status_type.status_text}', '#{@comment_status_type.color_name}'"})
        format.html { redirect_to comment_status_types_path, notice: 'Comment status type was successfully created.' }
        format.json { render :show, status: :created, location: @comment_status_type }
      else
        set_select_options
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
        if @comment_status_type.previous_changes.any?
          save_change_log(current_user,{object_type: 'comment status type', action_type: 'edit', description: "edited comment status type ID ##{@comment_status_type.id} to '#{@comment_status_type.status_text}', '#{@comment_status_type.color_name}'"})
        end
        format.html { redirect_to comment_status_types_path, notice: 'Comment status type was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment_status_type }
      else
        set_select_options
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
      firstCST = current_rulemaking.comment_status_types.where.not(id: @comment_status_type.id).order(:order_in_list).first
      reassign_comments(@comment_status_type,firstCST)

      current_CST_num = @comment_status_type.order_in_list
      save_change_log(current_user,{object_type: 'comment status type', action_type: 'delete', description: "deleted comment status type ID ##{@comment_status_type.id} '#{@comment_status_type.status_text}'. Any corresponding comments were reassigned to ID #{firstCST.id}, '#{firstCST.status_text}'."})
      @comment_status_type.destroy
      handle_delete_of_order_in_list(current_rulemaking.comment_status_types,current_CST_num)
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
      @comment_status_type = current_rulemaking.comment_status_types.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_status_type_params
      p = params.require(:comment_status_type).permit(:status_text, :order_in_list)
      p2 = params.require(:comment_status_type).permit(:color_id)
      return p.merge(color_name: get_color_name(p2[:color_id]))
    end

    def move(up = true)
      cst = current_rulemaking.comment_status_types.find(params[:id])

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
        current_rulemaking.comment_status_types.where("order_in_list < ?",current.order_in_list).order("order_in_list DESC").first
      else
        current_rulemaking.comment_status_types.where("order_in_list > ?",current.order_in_list).order(:order_in_list).first
      end
    end

    def reassign_comments(reassign_from_cst, reassign_to_cst)
      current_rulemaking.comments.where(comment_status_type_id: reassign_from_cst.id).each do |com|
        com.comment_status_type_id = reassign_to_cst.id
        com.save
      end
    end

    def set_select_options
      @color_category_and_names_list = color_category_and_names_list
    end
end
