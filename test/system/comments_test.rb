require "application_system_test_case"

#class CommentsTest < ApplicationSystemTestCase
class CommentsTest < ActionDispatch::SystemTestCase

  test "visiting the index" do
    visit comments_url
    assert_selector "h1", text: "Comments"
  end
  
end
