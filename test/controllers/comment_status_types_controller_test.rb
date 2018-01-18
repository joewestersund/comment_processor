require 'test_helper'

class CommentStatusTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment_status_type = comment_status_types(:one)
    sign_in_as users(:user1)
  end

  test "should get index" do
    get comment_status_types_url
    assert_response :success
  end

  test "should get new" do
    get new_comment_status_type_url
    assert_response :success
  end

  test "should create comment_status_type" do
    assert_difference('CommentStatusType.count') do
      post comment_status_types_url, params: { comment_status_type: { status_text: "new status text not used elsewhere" } }
    end

    assert_redirected_to comment_status_types_url
  end

  test "should show comment_status_type" do
    get comment_status_type_url(@comment_status_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_comment_status_type_url(@comment_status_type)
    assert_response :success
  end

  test "should update comment_status_type" do
    patch comment_status_type_url(@comment_status_type), params: { comment_status_type: { status_text: @comment_status_type.status_text } }
    assert_redirected_to comment_status_types_url
  end

  test "should destroy comment_status_type" do
    assert_difference('CommentStatusType.count', -1) do
      delete comment_status_type_url(@comment_status_type)
    end

    assert_redirected_to comment_status_types_url
  end
end
