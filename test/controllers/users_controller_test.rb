require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user1)
    sign_in_as users(:user1)
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

  test "should update user" do
    @user2 = users(:user2)
    patch user_url(@user2), params: { user: { name: @user2.name, email: @user2.email, admin: @user2.admin } }

    assert_redirected_to users_url
  end

  test "should update profile" do
    patch user_url(@user), params: { user: { email: @user.email, name: @user.name } }
    assert_redirected_to profile_edit_url
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
