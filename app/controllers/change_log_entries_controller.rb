class ChangeLogEntriesController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user, only: [:edit, :create, :update, :destroy]
  before_action :not_read_only_user, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_change_log_entry, only: [:show, :edit, :update, :destroy]

  # GET /change_log_entries
  # GET /change_log_entries.json
  def index
    @change_log_entries = ChangeLogEntry.all.order(created_at: :desc)
  end

  # GET /change_log_entries/1
  # GET /change_log_entries/1.json
  def show
  end

  # GET /change_log_entries/new
  def new
    @change_log_entry = ChangeLogEntry.new
  end

  # GET /change_log_entries/1/edit
  def edit
  end

  # POST /change_log_entries
  # POST /change_log_entries.json
  def create
    @change_log_entry = ChangeLogEntry.new(change_log_entry_params)

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

  # PATCH/PUT /change_log_entries/1
  # PATCH/PUT /change_log_entries/1.json
  def update
    respond_to do |format|
      if @change_log_entry.update(change_log_entry_params)
        format.html { redirect_to @change_log_entry, notice: 'Change log entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @change_log_entry }
      else
        format.html { render :edit }
        format.json { render json: @change_log_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /change_log_entries/1
  # DELETE /change_log_entries/1.json
  def destroy
    @change_log_entry.destroy
    respond_to do |format|
      format.html { redirect_to change_log_entries_url, notice: 'Change log entry was successfully destroyed.' }
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
