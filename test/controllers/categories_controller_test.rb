require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:one)
    sign_in_as users(:user1)
  end

  test "should get index" do
    get categories_url
    assert_response :success
  end

  test "should get new" do
    get new_category_url
    assert_response :success
  end

  test "should create category" do
    assert_difference('Category.count') do
      post categories_url, params: { category: { action_needed: @category.action_needed, category_name: "new category name", assigned_to_id: @category.assigned_to_id, response_text: @category.response_text, category_status_type_id: @category.category_status_type_id, description: @category.description } }
    end

    assert_redirected_to edit_category_url(Category.last)
  end

  test "should show category" do
    get category_url(@category)
    assert_response :success
  end

  test "should get edit" do
    get edit_category_url(@category)
    assert_response :success
  end

  test "should update category" do
    patch category_url(@category), params: { category: { action_needed: @category.action_needed, category_name: @category.category_name, assigned_to_id: @category.assigned_to_id, response_text: @category.response_text, category_status_type_id: @category.category_status_type_id, category_response_type_id: @category.category_response_type_id, description: @category.description, rule_change_made: @category.rule_change_made } }
    assert_redirected_to edit_category_url(@category)
  end

  test "should destroy category" do
    assert_difference('Category.count', -1) do
      delete category_url(@category)
    end

    assert_redirected_to categories_url
  end
end
