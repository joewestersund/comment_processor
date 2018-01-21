class ChangeLogEntriesController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_change_log_entry, only: [:show, :edit, :update, :destroy]
  before_action :set_select_options, only: [:new, :edit, :index]

  # GET /change_log_entries
  # GET /change_log_entries.json
  def index
    conditions = get_conditions
    @filtered = !conditions[0].empty?
    if conditions[0].empty?
      cle = ChangeLogEntry.all
    else
      cle = ChangeLogEntry.where(conditions)
    end
    @change_log_entries = cle.order(created_at: :desc).page(params[:page]).per_page(10)
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
        format.html { redirect_to change_log_entries_path, notice: 'Activity log entry was successfully created.' }
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
        format.html { redirect_to change_log_entries_path, notice: 'Activity log entry was successfully updated.' }
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
      format.html { redirect_to change_log_entries_url, notice: 'Activity log entry was successfully deleted.' }
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

    def set_select_options
      @users = User.order(:name).all
      @comments = ChangeLogEntry.joins(:comment).select('comment_id, order_in_list').group('comment_id, order_in_list').order('order_in_list')
      @categories = ChangeLogEntry.joins(:category).select('category_id, category_name').group('category_id, category_name').order('category_name')
      @object_types = ChangeLogEntry.select(:object_type).group(:object_type).order(:object_type)
      @action_types = ChangeLogEntry.select(:action_type).group(:action_type).order(:action_type)

    end

    def filter_params
      params.permit(:user_id,  :object_type, :action_type, :comment_id, :category_id, :description)
    end

    def get_conditions

      search_terms = ChangeLogEntry.new(filter_params)

      conditions = {}
      conditions_string = []

      conditions[:user_id] = search_terms.user_id if search_terms.user_id.present?
      conditions_string << "user_id = :user_id" if search_terms.user_id.present?

      conditions[:object_type] = search_terms.object_type if search_terms.object_type.present?
      conditions_string << "object_type = :object_type" if search_terms.object_type.present?

      conditions[:action_type] = search_terms.action_type if search_terms.action_type.present?
      conditions_string << "action_type = :action_type" if search_terms.action_type.present?

      conditions[:comment_id] = search_terms.comment_id if search_terms.comment_id.present?
      conditions_string << "comment_id = :comment_id" if search_terms.comment_id.present?

      conditions[:category_id] = search_terms.category_id if search_terms.category_id.present?
      conditions_string << "category_id = :category_id" if search_terms.category_id.present?

      conditions[:description] = "%#{search_terms.description}%" if search_terms.description.present?
      conditions_string << "description ILIKE :description" if search_terms.description.present?

      return [conditions_string.join(" AND "), conditions]
    end

end
