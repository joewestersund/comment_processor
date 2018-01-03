class CommentToneTypesController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user
  before_action :set_comment_tone_type, only: [:show, :edit, :update, :destroy]

  # GET /comment_tone_types
  # GET /comment_tone_types.json
  def index
    @comment_tone_types = CommentToneType.order(:order_in_list).all
  end

  # GET /comment_tone_types/1
  # GET /comment_tone_types/1.json
  def show
  end

  def move_up
    move(true)
  end

  def move_down
    move(false)
  end

  # GET /comment_tone_types/new
  def new
    @comment_tone_type = CommentToneType.new
  end

  # GET /comment_tone_types/1/edit
  def edit
  end

  # POST /comment_tone_types
  # POST /comment_tone_types.json
  def create
    @comment_tone_type = CommentToneType.new(comment_tone_type_params)

    #set the order_in_list
    ctt_max = CommentToneType.maximum(:order_in_list)
    @comment_tone_type.order_in_list = ctt_max.nil? ? 1 : ctt_max + 1

    respond_to do |format|
      if @comment_tone_type.save
        format.html { redirect_to comment_tone_types_path, notice: 'Comment tone type was successfully created.' }
        format.json { render :show, status: :created, location: @comment_tone_type }
      else
        format.html { render :new }
        format.json { render json: @comment_tone_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comment_tone_types/1
  # PATCH/PUT /comment_tone_types/1.json
  def update
    respond_to do |format|
      if @comment_tone_type.update(comment_tone_type_params)
        format.html { redirect_to @comment_tone_type, notice: 'Comment tone type was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment_tone_type }
      else
        format.html { render :edit }
        format.json { render json: @comment_tone_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comment_tone_types/1
  # DELETE /comment_tone_types/1.json
  def destroy
    @comment_tone_type.destroy
    respond_to do |format|
      format.html { redirect_to comment_tone_types_url, notice: 'Comment tone type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment_tone_type
      @comment_tone_type = CommentToneType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_tone_type_params
      params.require(:comment_tone_type).permit(:tone_text, :order_in_list)
    end

    def move(up = true)
      ctt = CommentToneType.find(params[:id])

      if ctt.present?
        ctt2 = get_adjacent(ctt,up)
        if ctt2.present?
          swap_and_save(ctt, ctt2)
          respond_to do |format|
            format.html { redirect_to comment_tone_types_path }
            format.json { head :no_content }
          end
          return
        end
      end
      respond_to do |format|
        format.html { redirect_to comment_tone_types_path, notice: "could not move" }
        format.json { render json: @comment_tone_type.errors, status: :unprocessable_entity }
      end
    end

    def get_adjacent(current, get_previous = false)
      if get_previous
        CommentToneType.where("order_in_list < ?",current.order_in_list).order("order_in_list DESC").first
      else
        CommentToneType.where("order_in_list > ?",current.order_in_list).order(:order_in_list).first
      end
    end
end
