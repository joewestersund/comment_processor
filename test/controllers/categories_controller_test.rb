require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:one)
    sign_in_as users(:regular_user)
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
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        post categories_url, params: { category: { action_needed: @category.action_needed, category_name: "new category name", assigned_to_id: @category.assigned_to_id, response_text: @category.response_text, category_status_type_id: @category.category_status_type_id, description: @category.description } }
      end
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

  test "should not write to log if no change" do
    assert_difference('ChangeLogEntry.count', 0) do
      patch category_url(@category), params: { category: { action_needed: @category.action_needed, category_name: @category.category_name, assigned_to_id: @category.assigned_to_id, response_text: @category.response_text, category_status_type_id: @category.category_status_type_id, category_response_type_id: @category.category_response_type_id, description: @category.description, rule_change_made: @category.rule_change_made } }
    end
    assert_redirected_to edit_category_url(@category)
  end

  test "should update category" do
    assert_difference('ChangeLogEntry.count', 1) do #should write to log
      patch category_url(@category), params: { category: { action_needed: @category.action_needed, category_name: "#{@category.category_name} and more", assigned_to_id: @category.assigned_to_id, response_text: @category.response_text, category_status_type_id: @category.category_status_type_id, category_response_type_id: @category.category_response_type_id, description: @category.description, rule_change_made: @category.rule_change_made } }
    end
    assert_redirected_to edit_category_url(@category)
  end

  test "non-admin can't renumber categories" do
    assert_equal(1, Category.find(1).order_in_list)
    assert_equal(2, Category.find(2).order_in_list)
    assert_equal(3, Category.find(3).order_in_list)
    assert_equal(4, Category.find(4).order_in_list)

    put categories_renumber_url

    assert_redirected_to welcome_url

    assert_equal(1, Category.find(1).order_in_list)
    assert_equal(2, Category.find(2).order_in_list)
    assert_equal(3, Category.find(3).order_in_list)
    assert_equal(4, Category.find(4).order_in_list)

  end

  test "admin can renumber categories" do
    sign_user_out
    sign_in_as users(:admin_user_1)

    assert_equal(1, Category.find(1).order_in_list)
    assert_equal(2, Category.find(2).order_in_list)
    assert_equal(3, Category.find(3).order_in_list)
    assert_equal(4, Category.find(4).order_in_list)

    put categories_renumber_url

    assert_redirected_to categories_path

    assert_equal(4, Category.find(1).order_in_list)
    assert_equal(2, Category.find(2).order_in_list)
    assert_equal(1, Category.find(3).order_in_list)
    assert_equal(3, Category.find(4).order_in_list)

  end

  test "non-admin can't merge categories" do
    action_needed_before = @category.action_needed
    comments_before = @category.comments

    assert_equal(action_needed_before, @category.action_needed)
    category2 = categories(:two)

    get categories_merge_url
    assert_redirected_to welcome_url

    put categories_merge_preview_url(to_category_id: @category, from_category_id: category2)
    assert_redirected_to welcome_url

    post categories_do_merge_url(@category, category2), params: { category: { action_needed: "#{@category.action_needed} plus some more", category_name: "#{@category.category_name} and more", assigned_to_id: @category.assigned_to_id, response_text: "#{@category.response_text} and more", category_status_type_id: @category.category_status_type_id, category_response_type_id: @category.category_response_type_id, description: @category.description, rule_change_made: @category.rule_change_made } }
    assert_redirected_to welcome_url

    @category.reload
    assert_equal(action_needed_before, @category.action_needed)
    assert_equal(comments_before, @category.comments)
    assert_not_equal(nil, category2.reload)
  end

  test "admin can merge categories" do
    sign_user_out
    sign_in_as users(:admin_user_1)
    category2 = categories(:two)

    action_needed_before = @category.action_needed
    comments_before = @category.comments
    merged_comments = (category2.comments - @category.comments)
    assert_equal(action_needed_before, @category.action_needed)

    get categories_merge_url
    assert_response :success

    put categories_merge_preview_url(to_category_id: @category, from_category_id: category2)
    assert_response :success

    post categories_do_merge_url(@category, category2), params: { category: { action_needed: "#{@category.action_needed} plus some more", category_name: "#{@category.category_name} and more", assigned_to_id: @category.assigned_to_id, response_text: "#{@category.response_text} and more", category_status_type_id: @category.category_status_type_id, category_response_type_id: @category.category_response_type_id, description: @category.description, rule_change_made: @category.rule_change_made } }
    assert_redirected_to edit_category_url(@category)

    @category.reload
    assert_not_equal(action_needed_before, @category.action_needed)
    assert_equal(merged_comments, @category.comments)
    assert_raises(Exception) do
      category2.reload #should not exist any more.
    end
  end

  test "non-admin can't copy a category" do
    count_before = Category.count

    get category_copy_url
    assert_redirected_to welcome_url

    put category_copy_url(category_id: @category)
    assert_redirected_to welcome_url

    assert_equal(count_before, Category.count)
  end

  test "admin can copy a category" do
    sign_user_out
    sign_in_as users(:admin_user_1)

    count_before = Category.count
    highest_category_id = Category.maximum(:id)

    get category_copy_url
    assert_response :success

    put category_copy_url(category_id: @category)

    new_category = Category.order(:id).last
    assert_redirected_to edit_category_url(new_category)

    assert_equal(count_before + 1, Category.count)

    assert_equal(new_category.category_name, "Copy of #{@category.category_name}")
    assert_equal(new_category.comments, @category.comments)

  end

  test "should destroy category" do
    assert_difference('Category.count', -1) do
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        delete category_url(@category)
      end
    end

    assert_redirected_to categories_url
  end
end
