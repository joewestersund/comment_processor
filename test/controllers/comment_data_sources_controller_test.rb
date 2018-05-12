require 'test_helper'

class CommentDataSourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment_data_source = comment_data_sources(:one)
    sign_in_as users(:admin_user_1)
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
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        post comment_data_sources_url, params: { comment_data_source: { active: @comment_data_source.active, comment_download_url: "#{@comment_data_source.comment_download_url}123", data_source_name: "#{@comment_data_source.data_source_name}456", description: @comment_data_source.description } }
      end
    end

    assert_redirected_to comment_data_sources_url
  end

  test "should get edit" do
    get edit_comment_data_source_url(@comment_data_source)
    assert_response :success
  end

  test "should update comment_data_source" do
    assert_difference('ChangeLogEntry.count', 1) do #should write to log
      patch comment_data_source_url(@comment_data_source), params: { comment_data_source: { active: @comment_data_source.active, comment_download_url: "#{@comment_data_source.comment_download_url}9", data_source_name: @comment_data_source.data_source_name, description: @comment_data_source.description } }
    end
    assert_redirected_to comment_data_sources_url
  end

  test "should destroy comment_data_source" do
    assert_difference('CommentDataSource.count', -1) do
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        delete comment_data_source_url(@comment_data_source)
      end
    end

    assert_redirected_to comment_data_sources_url
  end
end
