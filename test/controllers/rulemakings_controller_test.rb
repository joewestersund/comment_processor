require 'test_helper'

class RulemakingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rulemaking = rulemakings(:one)
    sign_in_as users(:application_admin_user_1)
  end

  test "should get index" do
    get rulemakings_url
    assert_response :success
  end

  test "should get new" do
    get new_rulemaking_url
    assert_response :success
  end

  test "should not create duplicate rulemaking" do
    assert_difference('Rulemaking.count', 0) do
      post rulemakings_url, params: { rulemaking: { agency: @rulemaking.agency, rulemaking_name: @rulemaking.rulemaking_name } }
    end

  end

  test "should create rulemaking" do
    new_rulemaking_name = "some name not used yet"
    assert_difference('Rulemaking.count') do
      post rulemakings_url, params: { rulemaking: { agency: "some agency", rulemaking_name: new_rulemaking_name, allow_push_import: true } }
    end

    assert_redirected_to rulemakings_url

    @new_rulemaking = Rulemaking.where(rulemaking_name: new_rulemaking_name).first
    assert_equal(CommentStatusType.default_list.count, @new_rulemaking.comment_status_types.count)
    assert_equal(SuggestedChangeStatusType.default_list.count, @new_rulemaking.suggested_change_status_types.count)
    assert_equal(SuggestedChangeResponseType.default_list.count, @new_rulemaking.suggested_change_response_types.count)
    assert_equal(CommentDataSource.default_list.count, @new_rulemaking.comment_data_sources.count)

  end

  test "should get edit" do
    get edit_rulemaking_url(@rulemaking)
    assert_response :success
  end

  test "should update rulemaking" do
    patch rulemaking_url(@rulemaking), params: { rulemaking: { agency: @rulemaking.agency, rulemaking_name: @rulemaking.rulemaking_name } }
    assert_redirected_to rulemakings_url
  end

  test "should destroy rulemaking" do
    assert_difference('Rulemaking.count', -1) do
      delete rulemaking_url(@rulemaking)
    end

    assert_redirected_to rulemakings_url
  end
end
