require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment = comments(:one)
    sign_in_as users(:user1)
  end

  test "should get index" do
    get comments_url
    assert_response :success
  end

  test "should get new" do
    get new_comment_url
    assert_response :success
  end

  test "should create manually added comment" do
    assert_difference('Comment.count') do
      post comments_url, params: { comment: { first_name: @comment.first_name, last_name: @comment.last_name, email: @comment.email, organization: @comment.organization, state: @comment.state, comment_text: @comment.comment_text, attachment_name: @comment.attachment_name, attachment_url: @comment.attachment_url, status_details: @comment.status_details, comment_status_type_id: @comment.comment_status_type_id, summary: @comment.summary, manually_entered: true, num_commenters: 1 } }
    end

    assert_redirected_to edit_comment_url(Comment.last)
  end

  test "should show comment" do
    get comment_url(@comment)
    assert_response :success
  end

  test "should get edit" do
    get edit_comment_url(@comment)
    assert_response :success
  end

  test "should update comment" do
    patch comment_url(@comment), params: { comment: { status_details: @comment.status_details, attachment_url: @comment.attachment_url, comment_text: @comment.comment_text, email: @comment.email, first_name: @comment.first_name, last_name: @comment.last_name, organization: @comment.organization, source_id: @comment.source_id, state: @comment.state, comment_status_type_id: @comment.comment_status_type_id, summary: @comment.summary } }
    assert_redirected_to edit_comment_url(@comment)
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete comment_url(@comment)
    end

    assert_redirected_to comments_url
  end
end
