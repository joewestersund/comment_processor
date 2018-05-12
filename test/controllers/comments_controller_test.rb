require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment = comments(:one)
    sign_in_as users(:regular_user)
  end

  test "should get index" do
    get comments_url
    assert_response :success
  end

  test "non-admin can't get new" do
    get new_comment_url
    assert_redirected_to welcome_url
  end

  test "admin can get new" do
    sign_user_out
    sign_in_as users(:admin_user_1)

    get new_comment_url
    assert_response :success
  end

  test "non-admin can't create manually added comment" do
    assert_no_difference('Comment.count') do
      assert_no_difference('ChangeLogEntry.count', 1) do #should write to log
        post comments_url, params: { comment: { first_name: @comment.first_name, last_name: @comment.last_name, email: @comment.email, organization: @comment.organization, state: @comment.state, comment_text: @comment.comment_text, attachment_name: @comment.attachment_name, attachment_url: @comment.attachment_url, notes: @comment.notes, comment_status_type_id: @comment.comment_status_type_id, summary: @comment.summary, manually_entered: true, num_commenters: 1, comment_data_source_id: @comment.comment_data_source_id } }
      end
    end

    assert_redirected_to welcome_url
  end

  test "admin can create manually added comment" do
    sign_user_out
    sign_in_as users(:admin_user_1)

    assert_difference('Comment.count') do
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        post comments_url, params: { comment: { first_name: @comment.first_name, last_name: @comment.last_name, email: @comment.email, organization: @comment.organization, state: @comment.state, comment_text: @comment.comment_text, attachment_name: @comment.attachment_name, attachment_url: @comment.attachment_url, notes: @comment.notes, comment_status_type_id: @comment.comment_status_type_id, summary: @comment.summary, manually_entered: true, num_commenters: 1, comment_data_source_id: @comment.comment_data_source_id } }
      end
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

  test "should not write to log if no change" do
    assert_difference('ChangeLogEntry.count', 0) do
      patch comment_url(@comment), params: { comment: { notes: @comment.notes, attachment_url: @comment.attachment_url, comment_text: @comment.comment_text, email: @comment.email, first_name: @comment.first_name, last_name: @comment.last_name, organization: @comment.organization, source_id: @comment.source_id, state: @comment.state, comment_status_type_id: @comment.comment_status_type_id, summary: @comment.summary, comment_data_source_id: @comment.comment_data_source_id } }
    end

    assert_redirected_to edit_comment_url(@comment)
  end

  test "should update comment" do
    assert_difference('ChangeLogEntry.count', 1) do #should write to log
      patch comment_url(@comment), params: { comment: { notes: "#{@comment.notes} and more", attachment_url: @comment.attachment_url, comment_text: @comment.comment_text, email: @comment.email, first_name: @comment.first_name, last_name: @comment.last_name, organization: @comment.organization, source_id: @comment.source_id, state: @comment.state, comment_status_type_id: @comment.comment_status_type_id, summary: @comment.summary, comment_data_source_id: @comment.comment_data_source_id } }
    end

    assert_redirected_to edit_comment_url(@comment)
  end

  test "non-admin can't clean comment" do
    needs_cleaning = comments(:needs_cleaning)
    initial_text = 'consider this&amp;mdash; all California&amp;rsquo;s rules'
    assert_equal(initial_text,needs_cleaning.comment_text)
    put comments_do_cleanup_url
    assert_redirected_to welcome_url
    needs_cleaning.reload #reload attributes from database
    assert_equal(initial_text,needs_cleaning.comment_text)
  end

  test "admin can clean comment" do
    sign_user_out
    sign_in_as users(:admin_user_1)

    needs_cleaning = comments(:needs_cleaning)
    assert_equal('consider this&amp;mdash; all California&amp;rsquo;s rules',needs_cleaning.comment_text)
    put comments_do_cleanup_url
    assert_redirected_to comments_url
    needs_cleaning.reload #reload attributes from database
    assert_equal("consider this- all California's rules",needs_cleaning.comment_text)
  end

  test "non-admin can't destroy comment" do
    assert_no_difference('Comment.count', -1) do
      assert_no_difference('ChangeLogEntry.count', 1) do #should write to log
        delete comment_url(@comment)
      end
    end

    assert_redirected_to welcome_url
  end

  test "admin can destroy comment" do
    sign_user_out
    sign_in_as users(:admin_user_1)

    assert_difference('Comment.count', -1) do
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        delete comment_url(@comment)
      end
    end

    assert_redirected_to comments_url
  end
end
