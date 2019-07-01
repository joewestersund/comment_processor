class SuggestedChangeStatusTypesController < ApplicationController
  include ChangeLogEntriesHelper
  include ColorHelper

  before_action :signed_in_user
  before_action :user_with_permissions_to_a_rulemaking
  before_action :admin_user
  before_action :not_read_only_user, only: [:new, :edit, :create, :update, :destroy, :move_up, :move_down]
  before_action :set_suggested_change_status_type, only: [:show, :edit, :update, :destroy]
  before_action :set_select_options, only: [:new, :edit]

  # GET /suggested_change_status_types
  # GET /suggested_change_status_types.json
  def index
    @suggested_change_status_types = current_rulemaking.suggested_change_status_types.order(:order_in_list)
  end

  def move_up
    move(true)
  end

  def move_down
    move(false)
  end

  # GET /suggested_change_status_types/1
  # GET /suggested_change_status_types/1.json
  def show
  end

  # GET /suggested_change_status_types/new
  def new
    @suggested_change_status_type = SuggestedChangeStatusType.new
    @suggested_change_status_type.rulemaking = current_rulemaking
  end

  # GET /suggested_change_status_types/1/edit
  def edit
  end

  # POST /suggested_change_status_types
  # POST /suggested_change_status_types.json
  def create
    @suggested_change_status_type = SuggestedChangeStatusType.new(suggested_change_status_type_params)
    @suggested_change_status_type.rulemaking = current_rulemaking

    #set the order_in_list
    cst_max = current_rulemaking.suggested_change_status_types.maximum(:order_in_list)
    @suggested_change_status_type.order_in_list = cst_max.nil? ? 1 : cst_max + 1

    respond_to do |format|
      if @suggested_change_status_type.save
        save_change_log(current_user,{object_type: 'suggested change status type', action_type: 'create', description: "created suggested change status type ID ##{@suggested_change_status_type.id} '#{@suggested_change_status_type.status_text}', '#{@suggested_change_status_type.color_name}'"})
        format.html { redirect_to suggested_change_status_types_path, notice: 'Suggested change status type was successfully created.' }
        format.json { render :show, status: :created, location: @suggested_change_status_type }
      else
        set_select_options
        format.html { render :new }
        format.json { render json: @suggested_change_status_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suggested_change_status_types/1
  # PATCH/PUT /suggested_change_status_types/1.json
  def update
    respond_to do |format|
      if @suggested_change_status_type.update(suggested_change_status_type_params)
        if @suggested_change_status_type.previous_changes.any?
          save_change_log(current_user,{object_type: 'suggested change status type', action_type: 'edit', description: "edited suggested change status type ID ##{@suggested_change_status_type.id} to '#{@suggested_change_status_type.status_text}', '#{@suggested_change_status_type.color_name}'"})
        end
        format.html { redirect_to suggested_change_status_types_path, notice: 'Suggested change status type was successfully updated.' }
        format.json { render :show, status: :ok, location: @suggested_change_status_type }
      else
        set_select_options
        format.html { render :edit }
        format.json { render json: @suggested_change_status_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suggested_change_status_types/1
  # DELETE /suggested_change_status_types/1.json
  def destroy
    if current_rulemaking.suggested_change_status_types.count > 1
      #reassign any suggested changes of this type to the first remaining status type.
      firstCST = current_rulemaking.suggested_change_status_types.where.not(id: @suggested_change_status_type.id).order(:order_in_list).first
      reassign_suggested_changes(@suggested_change_status_type,firstCST)

      current_CST_num = @suggested_change_status_type.order_in_list
      save_change_log(current_user,{object_type: 'suggested change status type', action_type: 'delete', description: "deleted suggested change status type ID ##{@suggested_change_status_type.id} '#{@suggested_change_status_type.status_text}'. Any corresponding suggested changes were reassigned to ID ##{firstCST.id} '#{firstCST.status_text}'."})
      @suggested_change_status_type.destroy
      handle_delete_of_order_in_list(current_rulemaking.suggested_change_status_types,current_CST_num)
      respond_to do |format|
        format.html { redirect_to suggested_change_status_types_url, notice: "Suggested change status type was successfully deleted. Any suggested changes assigned to this status were reassigned to '#{firstCST.status_text}'." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to suggested_change_status_types_url, error: 'Cannot delete the last suggested change status type.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_suggested_change_status_type
      @suggested_change_status_type = current_rulemaking.suggested_change_status_types.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def suggested_change_status_type_params
      p = params.require(:suggested_change_status_type).permit(:status_text, :order_in_list)
      p2 = params.require(:suggested_change_status_type).permit(:color_id)
      return p.merge(color_name: get_color_name(p2[:color_id]))
    end

    def move(up = true)
      cst = current_rulemaking.suggested_change_status_types.find(params[:id])

      if cst.present?
        cst2 = get_adjacent(cst,up)
        if cst2.present?
          swap_and_save(cst, cst2)
          respond_to do |format|
            format.html { redirect_to suggested_change_status_types_path }
            format.json { head :no_content }
          end
          return
        end
      end
      respond_to do |format|
        format.html { redirect_to suggested_change_status_types_path, notice: "could not move" }
        format.json { render json: @suggested_change_status_type.errors, status: :unprocessable_entity }
      end
    end

    def get_adjacent(current, get_previous = false)
      if get_previous
        current_rulemaking.suggested_change_status_types.where("order_in_list < ?",current.order_in_list).order("order_in_list DESC").first
      else
        current_rulemaking.suggested_change_status_types.where("order_in_list > ?",current.order_in_list).order(:order_in_list).first
      end
    end

    def reassign_suggested_changes(reassign_from_cst, reassign_to_cst)
      current_rulemaking.suggested_changes.where(suggested_change_status_type_id: reassign_from_cst.id).each do |cat|
        cat.suggested_change_status_type_id = reassign_to_cst.id
        cat.save
      end
    end

    def set_select_options
      @color_category_and_names_list = color_category_and_names_list
    end
end
