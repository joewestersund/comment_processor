require 'test_helper'

class ChangeLogEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @change_log_entry = change_log_entries(:change_to_comment)
    sign_in_as users(:admin_user_1)
  end

  test "should get index" do
    get change_log_entries_url
    assert_response :success
  end

  test "should get new" do
    get new_change_log_entry_url
    assert_response :success
  end

  test "should create change log entry" do
    assert_difference('ChangeLogEntry.count') do
      post change_log_entries_url, params: { change_log_entry: { category_id: @change_log_entry.category_id, comment_id: @change_log_entry.comment_id, description: @change_log_entry.description, user_id: @change_log_entry.user_id } }
    end

    assert_redirected_to change_log_entries_url
  end

  test "should show change log entry" do
    get change_log_entry_url(@change_log_entry)
    assert_response :success
  end

  test "should get edit" do
    get edit_change_log_entry_url(@change_log_entry)
    assert_response :success
  end

  test "should update change log entry" do
    patch change_log_entry_url(@change_log_entry), params: { change_log_entry: { category_id: @change_log_entry.category_id, comment_id: @change_log_entry.comment_id, description: @change_log_entry.description, user_id: @change_log_entry.user_id } }
    assert_redirected_to change_log_entries_url
  end

  test "should destroy change log entry" do
    assert_difference('ChangeLogEntry.count', -1) do
      delete change_log_entry_url(@change_log_entry)
    end

    assert_redirected_to change_log_entries_url
  end
end
