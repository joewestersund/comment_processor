require 'test_helper'

class RulemakingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rulemaking = rulemakings(:one)
  end

  test "should get index" do
    get rulemakings_url
    assert_response :success
  end

  test "should get new" do
    get new_rulemaking_url
    assert_response :success
  end

  test "should create rulemaking" do
    assert_difference('Rulemaking.count') do
      post rulemakings_url, params: { rulemaking: { agency: @rulemaking.agency, rulemaking_name: @rulemaking.rulemaking_name } }
    end

    assert_redirected_to rulemaking_url(Rulemaking.last)
  end

  test "should show rulemaking" do
    get rulemaking_url(@rulemaking)
    assert_response :success
  end

  test "should get edit" do
    get edit_rulemaking_url(@rulemaking)
    assert_response :success
  end

  test "should update rulemaking" do
    patch rulemaking_url(@rulemaking), params: { rulemaking: { agency: @rulemaking.agency, rulemaking_name: @rulemaking.rulemaking_name } }
    assert_redirected_to rulemaking_url(@rulemaking)
  end

  test "should destroy rulemaking" do
    assert_difference('Rulemaking.count', -1) do
      delete rulemaking_url(@rulemaking)
    end

    assert_redirected_to rulemakings_url
  end
end
