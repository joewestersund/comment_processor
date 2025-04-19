require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  setup do
    PW = 'password'
    u = users(:admin_user_1)
    
    visit signin_url
    assert_selector "h1", text: "Sign in"

    fill_in "Email", with: u.email
    fill_in "Password", with: PW

    click_on 'Sign in'
    assert_selector "h1", text: "Comments"
  end

  test "visiting the index" do
    visit comments_url
    assert_selector "h1", text: "Comments"
  end
  
end
