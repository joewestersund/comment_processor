require 'test_helper'

class SuggestedChangesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @suggested_change = suggested_changes(:one)
    sign_in_as users(:regular_user)
  end

  test "should get index" do
    get suggested_changes_url
    assert_response :success
  end

  test "should get new" do
    get new_suggested_change_url
    assert_response :success
  end

  test "should create suggested_change" do
    assert_difference('SuggestedChange.count') do
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        post suggested_changes_url, params: { suggested_change: { action_needed: @suggested_change.action_needed, suggested_change_name: "new suggested_change name", assigned_to_id: @suggested_change.assigned_to_id, response_text: @suggested_change.response_text, suggested_change_status_type_id: @suggested_change.suggested_change_status_type_id, description: @suggested_change.description } }
      end
    end

    assert_redirected_to edit_suggested_change_url(SuggestedChange.last)
  end

  test "should show suggested_change" do
    get suggested_change_url(@suggested_change)
    assert_response :success
  end

  test "should get edit" do
    get edit_suggested_change_url(@suggested_change)
    assert_response :success
  end

  test "should not write to log if no change" do
    assert_difference('ChangeLogEntry.count', 0) do
      patch suggested_change_url(@suggested_change), params: { suggested_change: { action_needed: @suggested_change.action_needed, suggested_change_name: @suggested_change.suggested_change_name, assigned_to_id: @suggested_change.assigned_to_id, response_text: @suggested_change.response_text, suggested_change_status_type_id: @suggested_change.suggested_change_status_type_id, suggested_change_response_type_id: @suggested_change.suggested_change_response_type_id, description: @suggested_change.description, rule_change_made: @suggested_change.rule_change_made } }
    end
    assert_redirected_to edit_suggested_change_url(@suggested_change)
  end

  test "should update suggested_change" do
    assert_difference('ChangeLogEntry.count', 1) do #should write to log
      patch suggested_change_url(@suggested_change), params: { suggested_change: { action_needed: @suggested_change.action_needed, suggested_change_name: "#{@suggested_change.suggested_change_name} and more", assigned_to_id: @suggested_change.assigned_to_id, response_text: @suggested_change.response_text, suggested_change_status_type_id: @suggested_change.suggested_change_status_type_id, suggested_change_response_type_id: @suggested_change.suggested_change_response_type_id, description: @suggested_change.description, rule_change_made: @suggested_change.rule_change_made } }
    end
    assert_redirected_to edit_suggested_change_url(@suggested_change)
  end

  test "non-admin can't renumber suggested_changes" do
    assert_equal(1, SuggestedChange.find(1).order_in_list)
    assert_equal(2, SuggestedChange.find(2).order_in_list)
    assert_equal(3, SuggestedChange.find(3).order_in_list)
    assert_equal(4, SuggestedChange.find(4).order_in_list)

    put suggested_changes_renumber_url

    assert_redirected_to welcome_url

    assert_equal(1, SuggestedChange.find(1).order_in_list)
    assert_equal(2, SuggestedChange.find(2).order_in_list)
    assert_equal(3, SuggestedChange.find(3).order_in_list)
    assert_equal(4, SuggestedChange.find(4).order_in_list)

  end

  test "admin can renumber suggested_changes" do
    sign_user_out
    sign_in_as users(:admin_user_1)

    assert_equal(1, SuggestedChange.find(1).order_in_list)
    assert_equal(2, SuggestedChange.find(2).order_in_list)
    assert_equal(3, SuggestedChange.find(3).order_in_list)
    assert_equal(4, SuggestedChange.find(4).order_in_list)

    put suggested_changes_renumber_url

    assert_redirected_to suggested_changes_path

    assert_equal(4, SuggestedChange.find(1).order_in_list)
    assert_equal(2, SuggestedChange.find(2).order_in_list)
    assert_equal(1, SuggestedChange.find(3).order_in_list)
    assert_equal(3, SuggestedChange.find(4).order_in_list)

  end

  test "non-admin can't merge suggested_changes" do
    action_needed_before = @suggested_change.action_needed
    comments_before = @suggested_change.comments

    assert_equal(action_needed_before, @suggested_change.action_needed)
    suggested_change2 = suggested_changes(:two)

    get suggested_changes_merge_url
    assert_redirected_to welcome_url

    put suggested_changes_merge_preview_url(to_suggested_change_id: @suggested_change, from_suggested_change_id: suggested_change2)
    assert_redirected_to welcome_url

    post suggested_changes_do_merge_url(@suggested_change, suggested_change2), params: { suggested_change: { action_needed: "#{@suggested_change.action_needed} plus some more", suggested_change_name: "#{@suggested_change.suggested_change_name} and more", assigned_to_id: @suggested_change.assigned_to_id, response_text: "#{@suggested_change.response_text} and more", suggested_change_status_type_id: @suggested_change.suggested_change_status_type_id, suggested_change_response_type_id: @suggested_change.suggested_change_response_type_id, description: @suggested_change.description, rule_change_made: @suggested_change.rule_change_made } }
    assert_redirected_to welcome_url

    @suggested_change.reload
    assert_equal(action_needed_before, @suggested_change.action_needed)
    assert_equal(comments_before, @suggested_change.comments)
    assert_not_equal(nil, suggested_change2.reload)
  end

  test "admin can merge suggested_changes" do
    sign_user_out
    sign_in_as users(:admin_user_1)
    suggested_change2 = suggested_changes(:two)

    action_needed_before = @suggested_change.action_needed
    comments_before = @suggested_change.comments
    merged_comments = (suggested_change2.comments - @suggested_change.comments)
    assert_equal(action_needed_before, @suggested_change.action_needed)

    get suggested_changes_merge_url
    assert_response :success

    put suggested_changes_merge_preview_url(to_suggested_change_id: @suggested_change, from_suggested_change_id: suggested_change2)
    assert_response :success

    post suggested_changes_do_merge_url(@suggested_change, suggested_change2), params: { suggested_change: { action_needed: "#{@suggested_change.action_needed} plus some more", suggested_change_name: "#{@suggested_change.suggested_change_name} and more", assigned_to_id: @suggested_change.assigned_to_id, response_text: "#{@suggested_change.response_text} and more", suggested_change_status_type_id: @suggested_change.suggested_change_status_type_id, suggested_change_response_type_id: @suggested_change.suggested_change_response_type_id, description: @suggested_change.description, rule_change_made: @suggested_change.rule_change_made } }
    assert_redirected_to edit_suggested_change_url(@suggested_change)

    @suggested_change.reload
    assert_not_equal(action_needed_before, @suggested_change.action_needed)
    assert_equal(merged_comments, @suggested_change.comments)
    assert_raises(Exception) do
      suggested_change2.reload #should not exist any more.
    end
  end

  test "non-admin can't copy a suggested_change" do
    count_before = SuggestedChange.count

    get suggested_change_copy_url
    assert_redirected_to welcome_url

    put suggested_change_copy_url(suggested_change_id: @suggested_change)
    assert_redirected_to welcome_url

    assert_equal(count_before, SuggestedChange.count)
  end

  test "admin can copy a suggested_change" do
    sign_user_out
    sign_in_as users(:admin_user_1)

    count_before = SuggestedChange.count
    highest_suggested_change_id = SuggestedChange.maximum(:id)

    get suggested_change_copy_url
    assert_response :success

    put suggested_change_copy_url(suggested_change_id: @suggested_change)

    new_suggested_change = SuggestedChange.order(:id).last
    assert_redirected_to edit_suggested_change_url(new_suggested_change)

    assert_equal(count_before + 1, SuggestedChange.count)

    assert_equal(new_suggested_change.suggested_change_name, "Copy of #{@suggested_change.suggested_change_name}")
    assert_equal(new_suggested_change.comments, @suggested_change.comments)

  end

  test "should destroy suggested_change" do
    assert_difference('SuggestedChange.count', -1) do
      assert_difference('ChangeLogEntry.count', 1) do #should write to log
        delete suggested_change_url(@suggested_change)
      end
    end

    assert_redirected_to suggested_changes_url
  end
end
