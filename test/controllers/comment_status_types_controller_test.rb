require 'test_helper'

class CommentStatusTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment_status_type = comment_status_types(:one)
    sign_in_as users(:admin_user_1)
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
    assert_difference('CommentStatusType.count', 1) do
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        post comment_status_types_url, params: { comment_status_type: { status_text: "new status text not used elsewhere" } }
      end
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

  test "shouldn't write to log if no change" do
    assert_difference('ChangeLogEntry.count', 0) do
      #color_id = 0 for indianred, which is the starting color for this fixture
      patch comment_status_type_url(@comment_status_type), params: { comment_status_type: { status_text: @comment_status_type.status_text, order_in_list: @comment_status_type.order_in_list, color_id: 0 } }
    end
    assert_redirected_to comment_status_types_url
  end

  test "should update comment_status_type" do
    assert_difference('ChangeLogEntry.count', 1) do #should write to log
      patch comment_status_type_url(@comment_status_type), params: { comment_status_type: { status_text: "#{@comment_status_type.status_text} and more" } }
    end
    assert_redirected_to comment_status_types_url
  end

  test "should destroy comment_status_type" do
    assert_difference('CommentStatusType.count', -1) do
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        delete comment_status_type_url(@comment_status_type)
      end
    end

    assert_redirected_to comment_status_types_url
  end
end
