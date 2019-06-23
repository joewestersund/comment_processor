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

  test "non- app admin shouldn't get edit" do
    get edit_user_url(@user)
    assert_redirected_to welcome_url
  end

  test "app admin should get edit" do
    sign_user_out
    sign_in_as users(:application_admin_user_1)

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

  test "regular admin shouldn't be able to update user" do
    @user2 = users(:regular_user)
    patch user_url(@user2), params: { user: { name: "a changed name", email: @user2.email, application_admin: @user2.application_admin } }

    assert_redirected_to welcome_url

    user2_name = User.find_by(email: @user2.email).name

    assert_equal(user2_name, @user2.name)

  end

  test "app admin should be able to update user" do
    sign_user_out
    sign_in_as users(:application_admin_user_1)

    @user2 = users(:regular_user)
    patch user_url(@user2), params: { user: { name: "a changed name", email: @user2.email, application_admin: @user2.application_admin } }

    assert_redirected_to users_url

    user2_name = User.find_by(email: @user2.email).name

    assert_not_equal(user2_name, @user2.name)

  end

  test "should update profile" do
    new_name = "some other name"
    patch profile_update_url(@user), params: { user: { name: new_name, email: @user.email } }
    assert_redirected_to profile_edit_url

    assert_equal(User.find_by(email: @user.email).name, new_name)
  end

  test "should not destroy user with change log entries" do
    assert_difference('User.count', 0) do
      delete user_url(@user)
    end

  end

  test "regular admin should not be able to destroy user " do
    assert_difference('User.count', 0) do
      @user.change_log_entries.delete_all
      delete user_url(@user)
    end

    assert_redirected_to welcome_url #since this user should get rejected before control action is triggered
  end

  test "application admin user should be able to destroy user without change log entries" do
    sign_user_out

    get comments_url
    assert_redirected_to signin_url

    sign_in_as users(:application_admin_user_1)


    assert_difference('User.count', -1) do
      @user.change_log_entries.delete_all
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end

  test "should get forgot password screen" do
    sign_user_out
    get password_forgot_url
    assert_response :success
  end

  test "should send password reset email" do
    sign_user_out
    post password_send_reset_email_url, params: { user: { email: @user.email } }

    assert_redirected_to password_forgot_url
  end

  test "should not remove last application admin" do
    sign_user_out

    sign_in_as users(:application_admin_user_1)

    assert_difference('User.where({application_admin: true, active: true}).count',-1) do
      @other_app_admin = users(:application_admin_user_2)
      patch user_url(@other_app_admin), params: { user: { application_admin: false }}
    end

    assert_redirected_to users_url

    assert_difference('User.where({application_admin: true, active: true}).count', 0) do
      @last_app_admin = users(:application_admin_user_1)
      patch user_url(@last_app_admin), params: { user: { application_admin: false }}
    end

    assert_redirected_to users_url
  end

end
