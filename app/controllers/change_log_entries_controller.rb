class ChangeLogEntriesController < ApplicationController
  before_action :set_change_log_entry, only: [:show, :edit, :update, :destroy]

  # GET /changes
  # GET /changes.json
  def index
    @changes = Change.all
  end

  # GET /changes/1
  # GET /changes/1.json
  def show
  end

  # GET /changes/new
  def new
    @change = Change.new
  end

  # GET /changes/1/edit
  def edit
  end

  # POST /changes
  # POST /changes.json
  def create
    @change_log_entry = ChangeLogEntry.new(change_params)

    respond_to do |format|
      if @change_log_entry.save
        format.html { redirect_to @change_log_entry, notice: 'Change log entry was successfully created.' }
        format.json { render :show, status: :created, location: @change_log_entry }
      else
        format.html { render :new }
        format.json { render json: @change_log_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /changes/1
  # PATCH/PUT /changes/1.json
  def update
    respond_to do |format|
      if @change_log_entry.update(change_params)
        format.html { redirect_to @change_log_entry, notice: 'Change log entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @change_log_entry }
      else
        format.html { render :edit }
        format.json { render json: @change_log_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /changes/1
  # DELETE /changes/1.json
  def destroy
    @change_log_entry.destroy
    respond_to do |format|
      format.html { redirect_to changes_url, notice: 'Change log entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_change_log_entry
      @change_log_entry = ChangeLogEntry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def change_log_entry_params
      params.require(:change_log_entry).permit(:description, :comment_id, :category_id, :user_id)
    end
end
