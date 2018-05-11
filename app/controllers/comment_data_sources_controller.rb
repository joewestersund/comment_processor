class CommentDataSourcesController < ApplicationController
  before_action :set_comment_data_source, only: [:show, :edit, :update, :destroy]

  # GET /comment_data_sources
  # GET /comment_data_sources.json
  def index
    @comment_data_sources = CommentDataSource.all
  end

  # GET /comment_data_sources/1
  # GET /comment_data_sources/1.json
  def show
  end

  # GET /comment_data_sources/new
  def new
    @comment_data_source = CommentDataSource.new
  end

  # GET /comment_data_sources/1/edit
  def edit
  end

  # POST /comment_data_sources
  # POST /comment_data_sources.json
  def create
    @comment_data_source = CommentDataSource.new(comment_data_source_params)

    respond_to do |format|
      if @comment_data_source.save
        format.html { redirect_to @comment_data_source, notice: 'Comment data source was successfully created.' }
        format.json { render :show, status: :created, location: @comment_data_source }
      else
        format.html { render :new }
        format.json { render json: @comment_data_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comment_data_sources/1
  # PATCH/PUT /comment_data_sources/1.json
  def update
    respond_to do |format|
      if @comment_data_source.update(comment_data_source_params)
        format.html { redirect_to @comment_data_source, notice: 'Comment data source was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment_data_source }
      else
        format.html { render :edit }
        format.json { render json: @comment_data_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comment_data_sources/1
  # DELETE /comment_data_sources/1.json
  def destroy
    @comment_data_source.destroy
    respond_to do |format|
      format.html { redirect_to comment_data_sources_url, notice: 'Comment data source was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment_data_source
      @comment_data_source = CommentDataSource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_data_source_params
      params.require(:comment_data_source).permit(:data_source_name, :description, :comment_download_url, :active)
    end
end
