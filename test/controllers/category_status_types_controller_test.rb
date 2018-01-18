require 'test_helper'

class CategoryStatusTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category_status_type = category_status_types(:one)
    sign_in_as users(:user1)
  end

  test "should get index" do
    get category_status_types_url
    assert_response :success
  end

  test "should get new" do
    get new_category_status_type_url
    assert_response :success
  end

  test "should create category_status_type" do
    assert_difference('CategoryStatusType.count') do
      post category_status_types_url, params: { category_status_type: { status_text: "new category status text not used elsewhere" } }
    end

    assert_redirected_to category_status_types_url
  end

  test "should show category_status_type" do
    get category_status_type_url(@category_status_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_category_status_type_url(@category_status_type)
    assert_response :success
  end

  test "should update category_status_type" do
    patch category_status_type_url(@category_status_type), params: { category_status_type: { status_text: @category_status_type.status_text } }
    assert_redirected_to category_status_types_url
  end

  test "should destroy category_status_type" do
    assert_difference('CategoryStatusType.count', -1) do
      delete category_status_type_url(@category_status_type)
    end

    assert_redirected_to category_status_types_url
  end
end
