require 'test_helper'

class SuggestedChangeStatusTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @suggested_change_status_type = suggested_change_status_types(:one)
    sign_in_as users(:admin_user_1)
  end

  test "should get index" do
    get suggested_change_status_types_url
    assert_response :success
  end

  test "should get new" do
    get new_suggested_change_status_type_url
    assert_response :success
  end

  test "should create suggested_change_status_type" do
    assert_difference('SuggestedChangeStatusType.count') do
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        post suggested_change_status_types_url, params: { suggested_change_status_type: { status_text: "new suggested change status text not used elsewhere" } }
      end
    end

    assert_redirected_to suggested_change_status_types_url
  end

  test "should show suggested_change_status_type" do
    get suggested_change_status_type_url(@suggested_change_status_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_suggested_change_status_type_url(@suggested_change_status_type)
    assert_response :success
  end

  test "shouldn't write to log if no change" do
    assert_difference('ChangeLogEntry.count', 0) do
      patch suggested_change_status_type_url(@suggested_change_status_type), params: { suggested_change_status_type: { status_text: @suggested_change_status_type.status_text, order_in_list: @suggested_change_status_type.order_in_list, color_id: 1  } }
    end
    assert_redirected_to suggested_change_status_types_url
  end

  test "should update suggested_change_status_type" do
    assert_difference('ChangeLogEntry.count', 1) do #should write to log
      patch suggested_change_status_type_url(@suggested_change_status_type), params: { suggested_change_status_type: { status_text: "#{@suggested_change_status_type.status_text} and more" } }
    end
    assert_redirected_to suggested_change_status_types_url
  end

  test "should destroy suggested_change_status_type" do
    assert_difference('SuggestedChangeStatusType.count', -1) do
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        delete suggested_change_status_type_url(@suggested_change_status_type)
      end
    end

    assert_redirected_to suggested_change_status_types_url
  end
end
