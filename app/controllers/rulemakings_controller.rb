class RulemakingsController < ApplicationController
  before_action :set_rulemaking, only: [:show, :edit, :update, :destroy]

  # GET /rulemakings
  # GET /rulemakings.json
  def index
    @rulemakings = Rulemaking.all
  end

  # GET /rulemakings/1
  # GET /rulemakings/1.json
  def show
  end

  # GET /rulemakings/new
  def new
    @rulemaking = Rulemaking.new
  end

  # GET /rulemakings/1/edit
  def edit
  end

  # POST /rulemakings
  # POST /rulemakings.json
  def create
    @rulemaking = Rulemaking.new(rulemaking_params)

    respond_to do |format|
      if @rulemaking.save
        format.html { redirect_to @rulemaking, notice: 'Rulemaking was successfully created.' }
        format.json { render :show, status: :created, location: @rulemaking }
      else
        format.html { render :new }
        format.json { render json: @rulemaking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rulemakings/1
  # PATCH/PUT /rulemakings/1.json
  def update
    respond_to do |format|
      if @rulemaking.update(rulemaking_params)
        format.html { redirect_to @rulemaking, notice: 'Rulemaking was successfully updated.' }
        format.json { render :show, status: :ok, location: @rulemaking }
      else
        format.html { render :edit }
        format.json { render json: @rulemaking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rulemakings/1
  # DELETE /rulemakings/1.json
  def destroy
    @rulemaking.destroy
    respond_to do |format|
      format.html { redirect_to rulemakings_url, notice: 'Rulemaking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rulemaking
      @rulemaking = Rulemaking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rulemaking_params
      params.require(:rulemaking).permit(:rulemaking_name, :agency, :active)
    end
end
