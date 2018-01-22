require 'test_helper'

class CategoryResponseTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category_response_type = category_response_types(:one)
    sign_in_as users(:admin_user_1)
  end

  test "should get index" do
    get category_response_types_url
    assert_response :success
  end

  test "should get new" do
    get new_category_response_type_url
    assert_response :success
  end

  test "should create category_response_type" do
    assert_difference('CategoryResponseType.count') do
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        post category_response_types_url, params: { category_response_type: { response_text: "some new text not used elsewhere" } }
      end
    end

    assert_redirected_to category_response_types_url
  end

  test "should show category_response_type" do
    get category_response_type_url(@category_response_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_category_response_type_url(@category_response_type)
    assert_response :success
  end

  test "should not write to log if no change" do
    assert_difference('ChangeLogEntry.count', 0) do
      patch category_response_type_url(@category_response_type), params: { category_response_type: { response_text: @category_response_type.response_text } }
    end
    assert_redirected_to category_response_types_url
  end

  test "should update category_response_type" do
    assert_difference('ChangeLogEntry.count', 1) do #should write to log
      patch category_response_type_url(@category_response_type), params: { category_response_type: { response_text: "#{@category_response_type.response_text} and more" } }
    end
    assert_redirected_to category_response_types_url
  end

  test "should destroy category_response_type" do
    assert_difference('CategoryResponseType.count', -1) do
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        delete category_response_type_url(@category_response_type)
      end
    end

    assert_redirected_to category_response_types_url
  end
end
