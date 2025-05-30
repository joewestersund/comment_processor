require "application_system_test_case"

class SuggestedChangesTest < ApplicationSystemTestCase
  test "visiting the index" do
    log_user_in(:admin_user_1, :one)
    visit suggested_changes_url
    assert_selector "h1", text: "Suggested Changes"
  end

  test "can filter on index page" do
    log_user_in(:admin_user_1, :one)
    visit suggested_changes_url
    assert_link("Edit")  # there are some suggested changes displayed

    click_on("Show/Hide Filter")
    fill_in("Suggested change name", with:"ZZZZYX")  # no suggested changes should have this comment text
    click_on("Search")

    assert_no_link("Edit")  # no suggested changes displayed

    click_on("Clear Filter")

    assert_link("Edit")  # there are some suggested changes displayed
  end

  test "can download excel file" do
    log_user_in(:admin_user_1, :one)
    visit suggested_changes_url
    assert_link("XLSX")  # there is a link to download as Excel

    click_on("XLSX")
    assert_link("download your Suggested Changes here")
    click_on("download your Suggested Changes here")

    visit "/suggested_changes.xlsx?"
    
  end

  test "visiting the edit page" do
    log_user_in(:admin_user_1, :one)
    visit suggested_changes_url
    first(:link, "Edit").click
    assert_selector "h1", text: "Edit Suggested Change"
  end

  test "creating a suggested change" do
    log_user_in(:admin_user_1, :one)
    visit suggested_changes_url
    max_id_before = SuggestedChange.order(:id).last.id

    first(:link, "New Suggested Change").click
    assert_selector "h1", text: "New Suggested Change"
    
    fill_in "Suggested change name", with: "Should change the rules thusly"
    fill_in "Suggested change description", with: "Some description here"

    first(:button, "Save").click

    sleep(1)
    max_id_after = SuggestedChange.order(:id).last.id
    assert_not_equal(max_id_before, max_id_after, "a new suggested change with a higher id should have been saved.") # a suggested change was saved

  end

  test "linking suggested change to a comment" do
    log_user_in(:admin_user_1, :one)

    visit suggested_changes_url
    first(:link, "Edit").click   # edit the first comment

    r = rulemakings(:one)

    first_sc_id = r.suggested_changes.order(Arel.sql('LOWER(suggested_change_name)')).first.id
    sc = SuggestedChange.find(first_sc_id)
    num_comments_before = sc.comments.count
    description_before = sc.description

    fill_in "Suggested change description", with: "Some text here.#{description_before}"

    # get the comments that aren't already linked to this suggested change
    comments = Comment.where.not(id: sc.comments.select(:id))

    assert comments.count > 0  # if there aren't any not already selected comments, then we need to change the test.
    
    select comments.first.key_info, from: "comments"
    first(:button, "Save").click  # save the change to this comment

    assert_text("Suggested Change was successfully updated.")

    sc = SuggestedChange.find(first_sc_id)
    assert_equal(num_comments_before + 1, sc.comments.count, "a new comment should have been added.")

  end

  test "deleting a suggested change" do
    rulemaking_fixture = :one
    log_user_in(:admin_user_1, rulemaking_fixture)
    visit suggested_changes_url

    r = rulemakings(rulemaking_fixture)
    first_sc_id = r.suggested_changes.order(Arel.sql('LOWER(suggested_change_name)')).first.id
    assert_not_equal(0, SuggestedChange.where(id: first_sc_id).count, "the suggested change should exist because it hasn't been deleted yet.")

    sc = SuggestedChange.where(id: first_sc_id).first
    confirm_msg = "Are you sure you want to delete '#{sc.suggested_change_name}'?"
    accept_alert(confirm_msg) do
      first(:link, "Delete").click
    end
    assert_selector "h1", text: "Suggested Changes" #back on the index page

    sleep 2
    assert_equal(0, SuggestedChange.where(id: first_sc_id).count, "deleted suggested change id should not be in database")
  end

  test "logged out user can't visit index" do
    log_user_in(:admin_user_1, :one)
    log_user_out

    sleep(1)
    visit suggested_changes_url
    assert_selector "h1", text: "Sign in"
  end


end
