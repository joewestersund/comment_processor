class SuggestedChangeResponseTypesController < ApplicationController
  include ChangeLogEntriesHelper
  include ColorHelper

  before_action :signed_in_user
  before_action :user_with_permissions_to_a_rulemaking
  before_action :admin_user
  before_action :not_read_only_user, only: [:new, :edit, :create, :update, :destroy, :move_up, :move_down]
  before_action :set_suggested_change_response_type, only: [:show, :edit, :update, :destroy]
  before_action :set_select_options, only: [:new, :edit]

  # GET /suggested_change_response_types
  # GET /suggested_change_response_types.json
  def index
    @suggested_change_response_types = current_rulemaking.suggested_change_response_types.order(:order_in_list).all
  end

  # GET /suggested_change_response_types/1
  # GET /suggested_change_response_types/1.json
  def show
  end

  def move_up
    move(true)
  end

  def move_down
    move(false)
  end

  # GET /suggested_change_response_types/new
  def new
    @suggested_change_response_type = SuggestedChangeResponseType.new
    @suggested_change_response_type.rulemaking = current_rulemaking
  end

  # GET /suggested_change_response_types/1/edit
  def edit
  end

  # POST /suggested_change_response_types
  # POST /suggested_change_response_types.json
  def create
    @suggested_change_response_type = SuggestedChangeResponseType.new(suggested_change_response_type_params)
    @suggested_change_response_type.rulemaking = current_rulemaking

    #set the order_in_list
    crt_max = current_rulemaking.suggested_change_response_types.maximum(:order_in_list)
    @suggested_change_response_type.order_in_list = crt_max.nil? ? 1 : crt_max + 1

    respond_to do |format|
      if @suggested_change_response_type.save
        save_change_log(current_user,{object_type: 'suggested change response type', action_type: 'create', description: "added suggested change response type ID ##{@suggested_change_response_type.id} '#{@suggested_change_response_type.response_text}', '#{@suggested_change_response_type.color_name}'"})
        format.html { redirect_to suggested_change_response_types_path, notice: 'Suggested change response type was successfully created.' }
        format.json { render :show, status: :created, location: @suggested_change_response_type }
      else
        set_select_options
        format.html { render :new }
        format.json { render json: @suggested_change_response_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suggested_change_response_types/1
  # PATCH/PUT /suggested_change_response_types/1.json
  def update
    respond_to do |format|
      if @suggested_change_response_type.update(suggested_change_response_type_params)
        if @suggested_change_response_type.previous_changes.any?
          save_change_log(current_user,{object_type: 'suggested change response type', action_type: 'edit', description: "edited suggested change response type ID ##{@suggested_change_response_type.id} to '#{@suggested_change_response_type.response_text}', '#{@suggested_change_response_type.color_name}'"})
        end
        format.html { redirect_to suggested_change_response_types_path, notice: 'Suggested change response type was successfully updated.' }
        format.json { render :show, status: :ok, location: @suggested_change_response_type }
      else
        set_select_options
        format.html { render :edit }
        format.json { render json: @suggested_change_response_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suggested_change_response_types/1
  # DELETE /suggested_change_response_types/1.json
  def destroy
    save_change_log(current_user,{object_type: 'Suggested change response type', action_type: 'delete', description: "deleted suggested change response type ID ##{@suggested_change_response_type.id} '#{@suggested_change_response_type.response_text}'"})
    #any suggested changes assigned to this response type will be set to null automatically by the foreign key constraint.
    current_CRT_num = @suggested_change_response_type.order_in_list
    @suggested_change_response_type.destroy
    handle_delete_of_order_in_list(current_rulemaking.suggested_change_response_types,current_CRT_num)
    respond_to do |format|
      format.html { redirect_to suggested_change_response_types_url, notice: 'Suggested change response type was successfully destroyed. Any suggested changes assigned to this response type have been set to response = nil.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_suggested_change_response_type
      @suggested_change_response_type = current_rulemaking.suggested_change_response_types.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def suggested_change_response_type_params
      p = params.require(:suggested_change_response_type).permit(:response_text, :order_in_list)
      p2 = params.require(:suggested_change_response_type).permit(:color_id)
      return p.merge(color_name: get_color_name(p2[:color_id]))
    end

    def move(up = true)
      crt = current_rulemaking.suggested_change_response_types.find(params[:id])

      if crt.present?
        crt2 = get_adjacent(crt,up)
        if crt2.present?
          swap_and_save(crt, crt2)
          respond_to do |format|
            format.html { redirect_to suggested_change_response_types_path }
            format.json { head :no_content }
          end
          return
        end
      end
      respond_to do |format|
        format.html { redirect_to suggested_change_response_types_path, notice: "could not move" }
        format.json { render json: @suggested_change_response_type.errors, status: :unprocessable_entity }
      end
    end

    def get_adjacent(current, get_previous = false)
      if get_previous
        current_rulemaking.suggested_change_response_types.where("order_in_list < ?",current.order_in_list).order("order_in_list DESC").first
      else
        current_rulemaking.suggested_change_response_types.where("order_in_list > ?",current.order_in_list).order(:order_in_list).first
      end
    end

    def set_select_options
      @color_category_and_names_list = color_category_and_names_list
    end
end
