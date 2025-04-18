require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  setup do
    PW = 'password'
    u = users(:admin_user_1)
    u.password = PW
    u.password_confirmation = PW
    u.save
    
    puts "u.name = #{u.name}"
    puts "u.email = #{u.email}"
    puts "u.active = #{u.active}"
    puts "u.last_rulemaking_viewed.id = #{u.last_rulemaking_viewed.id}"
    puts "u.last_rulemaking_viewed.name = #{u.last_rulemaking_viewed.rulemaking_name}"
    puts "u.user_permissions.first.rulemaking.rulemaking_name = #{u.user_permissions.first.rulemaking.rulemaking_name}"
    puts "u.save = #{u.save}"

    visit signin_url
    assert_selector "h1", text: "Sign in"

    fill_in "Email", with: u.email
    fill_in "Password", with: PW

    click_on 'Sign in'
    
    puts "got here 2"
  end

  test "visiting the index" do
    visit comments_url
    assert_selector "h1", text: "Comments"
  end
  
end
