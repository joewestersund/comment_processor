require "test_helper"
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  PW = 'password'

  def log_user_in(user, rulemaking=nil)
      u = users(user)

      visit signin_url
      assert_selector "h1", text: "Sign in"

      fill_in "Email", with: u.email
      fill_in "Password", with: PW

      click_on 'Sign in'
      assert_selector "h1", text: "Comments"

      if not rulemaking.nil?
        r = rulemakings(rulemaking)
        if u.rulemakings.count > 1
          # can only switch if there are multiple to choose from
          select r.rulemaking_name, from: "navbarDropdownRulemakings"
        end
        assert_text r.rulemaking_name
      end
  end

  def log_user_out()
    click_on("Account")  # open up the dropdown menu
    click_on("Log Out")
  end

  def save_manual_screenshot(filename)
    save_screenshot("tmp/screenshots/manual/#{filename}.png")
  end

  def get_test_filename()
    "test_image.jpg"
  end
  def get_test_file_path()
    "test/test files/#{get_test_filename}"
  end

end
