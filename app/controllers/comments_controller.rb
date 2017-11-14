class CommentsController < ApplicationController
  include CommentsHelper

  before_action :signed_in_user
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :add_to_category, :remove_from_category]
  before_action :set_select_options, only: [:new, :edit, :index]


  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.order(:source_id)
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  def import
    #import comments from the outside data source
    @data_source = rulemaking_data_source
  end

  def do_import
    #actually do the import
    comments_imported = import_comments_data(rulemaking_data_source)
    redirect_to comments_import_path, notice: "#{comments_imported} comment(s) were successfully imported into the database."
  end

  # PATCH/PUT /comments/1/add_to_category/2
  def add_to_category
    existing_cat = @comment.categories.find(params[:category_id])
  end

  # PATCH/PUT /comments/1/remove_from_category/2
  def remove_from_category

  end

  # GET /comments/1/edit
  def edit
    current_comment_source_id = @comment.source_id
    @previous_comment = Comment.where("source_id < ?", current_comment_source_id).order(:source_id).last
    @next_comment = Comment.where("source_id > ?", current_comment_source_id).order(:source_id).first
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update

    respond_to do |format|
      if @comment.update(comment_params) && update_comment_categories
        format.html { redirect_to edit_comment_path(@comment), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def update_comment_categories
      @categories = Category.where(:id => params[:comment_categories])
      @comment.categories.destroy_all   #disassociate the already added organizers
      @comment.categories << @categories
      true
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:source_id, :first_name, :last_name, :email, :organization, :state, :comment_text, :attachment_url, :summary, :comment_status_type_id, :action_needed)
    end

    def set_select_options
      @users = User.order(:name).all
      @categories = Category.order(:category_name).all
    end

    def search_params
      params.permit(:first_name, :last_name, :organization, :state, :email, :category_name, :comment_text, :summary, :comment_status_type_id)
    end

    def get_conditions

      search_terms = Transaction.new(search_params)

      conditions = {}
      conditions_string = []

      conditions[:start_date] = params[:start_date] if params[:start_date].present?
      conditions_string << "transaction_date >= :start_date" if params[:start_date].present?

      conditions[:end_date] = params[:end_date] if params[:end_date].present?
      conditions_string << "transaction_date <= :end_date" if params[:end_date].present?

      conditions[:month] = search_terms.month if search_terms.month.present?
      conditions_string << "month = :month" if search_terms.month.present?

      conditions[:day] = search_terms.day if search_terms.day.present?
      conditions_string << "day = :day" if search_terms.day.present?

      conditions[:year] = search_terms.year if search_terms.year.present?
      conditions_string << "year = :year" if search_terms.year.present?

      conditions[:vendor_name] = "%#{search_terms.vendor_name}%" if search_terms.vendor_name.present?
      conditions_string << "vendor_name ILIKE :vendor_name" if search_terms.vendor_name.present?

      conditions[:account_id] = search_terms.account_id if search_terms.account_id.present?
      conditions_string << "account_id = :account_id" if search_terms.account_id.present?

      conditions[:transaction_category_id] = search_terms.transaction_category_id if search_terms.transaction_category_id.present?
      conditions_string << "transaction_category_id = :transaction_category_id" if search_terms.transaction_category_id.present?

      conditions[:amount] = search_terms.amount if search_terms.amount.present?
      conditions_string << "amount = :amount" if search_terms.amount.present?

      conditions[:description] = "%#{search_terms.description}%" if search_terms.description.present?
      conditions_string << "description ILIKE :description" if search_terms.description.present?

      return [conditions_string.join(" AND "), conditions]
    end

end
