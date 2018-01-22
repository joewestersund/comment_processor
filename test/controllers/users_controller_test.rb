require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user_1)
    sign_in_as users(:admin_user_1)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { email: "some_new_address@example.com", name: @user.name, password: 'test_password', password_confirmation: 'test_password'} }
    end

    assert_redirected_to users_url
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "inactive user should not be able to log in" do
    sign_user_out

    get comments_url
    assert_redirected_to signin_url

    sign_in_as users(:inactive_user)

    get comments_url
    assert_redirected_to signin_url
  end

  test "should not update user to remove last admin" do
    assert_difference('User.where(admin: true).count',-1) do
      @user2 = users(:admin_user_2)
      patch user_url(@user2), params: { user: { name: @user2.name, email: @user2.email, admin: false } }
    end

    assert_no_difference('User.where(admin: true).count') do
      @user1 = users(:admin_user_1)
      patch user_url(@user1), params: { user: { name: @user1.name, email: @user1.email, admin: false } }
    end

    assert_redirected_to users_url
  end

  test "should update user" do
    @user2 = users(:regular_user)
    patch user_url(@user2), params: { user: { name: @user2.name, email: @user2.email, admin: @user2.admin } }

    assert_redirected_to users_url
  end

  test "should update profile" do
    patch user_url(@user), params: { user: { email: @user.email, name: @user.name } }
    assert_redirected_to profile_edit_url
  end

  test "should not destroy user with change log entries" do
    assert_raises(Exception) do
      delete user_url(@user)
    end

  end


  test "should destroy user without change log entries" do
    assert_difference('User.count', -1) do
      @user.change_log_entries.delete_all
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
