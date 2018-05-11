require 'test_helper'

class CommentDataSourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment_data_source = comment_data_sources(:one)
  end

  test "should get index" do
    get comment_data_sources_url
    assert_response :success
  end

  test "should get new" do
    get new_comment_data_source_url
    assert_response :success
  end

  test "should create comment_data_source" do
    assert_difference('CommentDataSource.count') do
      post comment_data_sources_url, params: { comment_data_source: { active: @comment_data_source.active, comment_download_url: @comment_data_source.comment_download_url, data_source_name: @comment_data_source.data_source_name, description: @comment_data_source.description, string: @comment_data_source.string } }
    end

    assert_redirected_to comment_data_source_url(CommentDataSource.last)
  end

  test "should show comment_data_source" do
    get comment_data_source_url(@comment_data_source)
    assert_response :success
  end

  test "should get edit" do
    get edit_comment_data_source_url(@comment_data_source)
    assert_response :success
  end

  test "should update comment_data_source" do
    patch comment_data_source_url(@comment_data_source), params: { comment_data_source: { active: @comment_data_source.active, comment_download_url: @comment_data_source.comment_download_url, data_source_name: @comment_data_source.data_source_name, description: @comment_data_source.description, string: @comment_data_source.string } }
    assert_redirected_to comment_data_source_url(@comment_data_source)
  end

  test "should destroy comment_data_source" do
    assert_difference('CommentDataSource.count', -1) do
      delete comment_data_source_url(@comment_data_source)
    end

    assert_redirected_to comment_data_sources_url
  end
end
