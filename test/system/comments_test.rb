require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase

  test "visiting the index" do
    log_user_in(:admin_user_1, :one)
    visit comments_url
    assert_selector "h1", text: "Comments"
    end

  test "visiting the edit page" do
    log_user_in(:admin_user_1, :one)
    visit comments_url
    first(:link, "Edit").click
    assert_selector "h1", text: "Edit Comment"
  end
  
  test "manually adding a comment" do
    log_user_in(:admin_user_1, :one)
    visit comments_url
    max_id_before = Comment.order(:id).last.id

    click_on("Manually enter a comment")
    assert_selector "h1", text: "New Comment"

    assert_no_text get_test_filename # file hasn't been uploaded yet

    fill_in "First name", with: "Jane"
    fill_in "Last name", with: "Doe."
    fill_in "Email", with: "jane.doe@example.com"
    fill_in "Comment text", with: "this is my comment. I approve of this message."

    attach_file "comment_attached_files", get_test_file_path  #upload a test file

    first(:link, "Save").click

    max_id_after = Comment.order(:id).last.id
    assert_not_equal(max_id_before, max_id_after, "a new comment with a higher id should have been saved.") # a comment was saved

    assert_text get_test_filename # file has been uploaded
  end

  test "linking comment to suggested change" do
    log_user_in(:admin_user_1, :one)

    visit comments_url
    first(:link, "Edit").click   # edit the first comment

    r = rulemakings(:one)
    c_id = r.comments.order(:order_in_list).first.id
    c = Comment.find(c_id)
    num_suggested_changes_before = c.suggested_changes.count
    comment_text_before = c.comment_text

    fill_in "Comment text", with: "this is my comment. I approve of this message.#{comment_text_before}"

    # get the suggested changes that aren't already linked to this commment
    scs = SuggestedChange.where.not(id: c.suggested_changes.select(:id))

    assert scs.count > 0  # if there aren't any not already selected Suggested Changes, then we need to change the test.


    select_box_text = "Tag one or more suggested changes to this comment. Click into the whitespace and type to filter."

    select scs.first.suggested_change_name, from: select_box_text
    first(:link, "Save").click  # save the change to this comment

    assert_text("Comment was successfully updated.")
    
    c = Comment.find(c_id)
    assert_equal(num_suggested_changes_before + 1, c.suggested_changes.count, "a new suggested change should have been added.")

  end

  test "deleting a comment" do
    rulemaking_fixture = :one
    log_user_in(:admin_user_1, rulemaking_fixture)
    visit comments_url

    r = rulemakings(rulemaking_fixture)
    first_comment_id = r.comments.order(:order_in_list).first.id
    assert_not_equal(0, Comment.where(id:first_comment_id).count, "the comment should exist because it hasn't been deleted yet.")

    regex_str = /Are you sure you want to delete comment #\d+\?/  # used https://rubular.com/ to test
    accept_alert(regex_str) do
      first(:link, "Delete").click
    end
    assert_selector "h1", text: "Comments" #back on the index page

    sleep 2
    assert_equal(0, Comment.where(id: first_comment_id).count, "deleted comment id should not be in database")
  end

  test "logged out user can't visit index" do
    log_user_in(:admin_user_1, :one)
    log_user_out
    visit comments_url
    assert_selector "h1", text: "Sign in"
  end

end
