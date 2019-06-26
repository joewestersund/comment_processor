class RulemakingsController < ApplicationController

  before_action :signed_in_user
  before_action :application_admin_user, except: [:switch]
  before_action :set_rulemaking, only: [:edit, :update, :destroy, :switch]

  # GET /rulemakings
  # GET /rulemakings.json
  def index
    @rulemakings = Rulemaking.order(:rulemaking_name)
  end

  # GET /rulemakings/new
  def new
    @rulemaking = Rulemaking.new
  end

  # GET /rulemakings/1/edit
  def edit
  end

  # POST /rulemakings/switch/:id
  def switch
    set_current_rulemaking(@rulemaking)
    redirect_to comments_path
  end

  # POST /rulemakings
  # POST /rulemakings.json
  def create
    @rulemaking = Rulemaking.new(rulemaking_params)
    add_defaults(@rulemaking)  #add default status types, etc

    respond_to do |format|
      if @rulemaking.save
        up = UserPermission.new(rulemaking: @rulemaking, user: current_user, admin: true)
        up.save
        set_current_rulemaking(@rulemaking)
        format.html { redirect_to rulemakings_path, notice: 'Rulemaking was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /rulemakings/1
  # PATCH/PUT /rulemakings/1.json
  def update
    respond_to do |format|
      if @rulemaking.update(rulemaking_params)
        format.html { redirect_to rulemakings_path, notice: 'Rulemaking was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /rulemakings/1
  # DELETE /rulemakings/1.json
  def destroy
    @rulemaking.destroy
    respond_to do |format|
      format.html { redirect_to rulemakings_url, notice: 'Rulemaking was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rulemaking
      @rulemaking = Rulemaking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rulemaking_params
      params.require(:rulemaking).permit(:rulemaking_name, :agency, :open_for_public_to_submit_comments, :open_for_public_to_view_comments)
    end

    def add_defaults(rulemaking)
      add_default_objects(rulemaking,CommentStatusType, 'status_text')
      add_default_objects(rulemaking,SuggestedChangeStatusType, 'status_text')
      add_default_objects(rulemaking,SuggestedChangeResponseType, 'response_text')
      add_default_objects(rulemaking,CommentDataSource, 'data_source_name', false)
    end

    def add_default_objects(rulemaking, klass, name_of_field, include_order_in_list = true)
      order_in_list = 1
      klass.default_list.each do |list_item|
        obj = klass.new({rulemaking: rulemaking})
        obj[name_of_field] = list_item
        obj.order_in_list = order_in_list if include_order_in_list
        obj.save
        order_in_list += 1
      end
    end
end
