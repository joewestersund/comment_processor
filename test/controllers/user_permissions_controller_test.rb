require 'test_helper'

class UserPermissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user_1)
    sign_in_as users(:admin_user_1)
    @user_permission = user_permissions(:regular_user_permission)
  end

  test "should get index" do
    get user_permissions_url
    assert_response :success
  end

  test "should get new" do
    get new_user_permission_url
    assert_response :success
  end

  test "should create user_permission" do
    new_user = users(:user_with_no_permissions_yet)
    assert_difference('UserPermission.count',1) do
      post user_permissions_url, params: { user_permission: { admin: false, read_only: false, user_id: new_user.id } }
    end

    assert_redirected_to user_permissions_url
  end

  test "should get edit" do
    get edit_user_permission_url(@user_permission)
    assert_response :success
  end

  test "should update user_permission" do
    patch user_permission_url(@user_permission), params: { user_permission: { admin: @user_permission.admin, read_only: @user_permission.read_only, rulemaking_id: @user_permission.rulemaking_id, user_id: @user_permission.user_id } }
    assert_redirected_to user_permissions_url
  end

  test "should destroy user_permission" do
    assert_difference('UserPermission.count', -1) do
      delete user_permission_url(@user_permission)
    end

    assert_redirected_to user_permissions_url
  end

end
