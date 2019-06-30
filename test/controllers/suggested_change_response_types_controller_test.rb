require 'test_helper'

class SuggestedChangeResponseTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @suggested_change_response_type = suggested_change_response_types(:one)
    sign_in_as users(:admin_user_1)
  end

  test "should get index" do
    get suggested_change_response_types_url
    assert_response :success
  end

  test "should get new" do
    get new_suggested_change_response_type_url
    assert_response :success
  end

  test "should create suggested_change_response_type" do
    assert_difference('SuggestedChangeResponseType.count') do
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        post suggested_change_response_types_url, params: { suggested_change_response_type: { response_text: "some new text not used elsewhere" } }
      end
    end

    assert_redirected_to suggested_change_response_types_url
  end

  test "should show suggested_change_response_type" do
    get suggested_change_response_type_url(@suggested_change_response_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_suggested_change_response_type_url(@suggested_change_response_type)
    assert_response :success
  end

  test "should not write to log if no change" do
    assert_difference('ChangeLogEntry.count', 0) do
      patch suggested_change_response_type_url(@suggested_change_response_type), params: { suggested_change_response_type: { response_text: @suggested_change_response_type.response_text, order_in_list: @suggested_change_response_type.order_in_list, color_id: 1  } }
    end
    assert_redirected_to suggested_change_response_types_url
  end

  test "should update suggested_change_response_type" do
    assert_difference('ChangeLogEntry.count', 1) do #should write to log
      patch suggested_change_response_type_url(@suggested_change_response_type), params: { suggested_change_response_type: { response_text: "#{@suggested_change_response_type.response_text} and more" } }
    end
    assert_redirected_to suggested_change_response_types_url
  end

  test "should destroy suggested_change_response_type" do
    assert_difference('SuggestedChangeResponseType.count', -1) do
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        delete suggested_change_response_type_url(@suggested_change_response_type)
      end
    end

    assert_redirected_to suggested_change_response_types_url
  end
end
