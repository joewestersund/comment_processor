require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get static_pages_about_url
    assert_response :success
  end

  test "should get welcome" do
    get static_pages_welcome_url
    assert_response :success
  end

end
