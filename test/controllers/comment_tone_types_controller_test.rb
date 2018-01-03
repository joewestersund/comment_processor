require 'test_helper'

class CommentToneTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment_tone_type = comment_tone_types(:one)
  end

  test "should get index" do
    get comment_tone_types_url
    assert_response :success
  end

  test "should get new" do
    get new_comment_tone_type_url
    assert_response :success
  end

  test "should create comment_tone_type" do
    assert_difference('CommentToneType.count') do
      post comment_tone_types_url, params: { comment_tone_type: { description_text: @comment_tone_type.description_text, order_in_list: @comment_tone_type.order_in_list } }
    end

    assert_redirected_to comment_tone_type_url(CommentToneType.last)
  end

  test "should show comment_tone_type" do
    get comment_tone_type_url(@comment_tone_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_comment_tone_type_url(@comment_tone_type)
    assert_response :success
  end

  test "should update comment_tone_type" do
    patch comment_tone_type_url(@comment_tone_type), params: { comment_tone_type: { description_text: @comment_tone_type.description_text, order_in_list: @comment_tone_type.order_in_list } }
    assert_redirected_to comment_tone_type_url(@comment_tone_type)
  end

  test "should destroy comment_tone_type" do
    assert_difference('CommentToneType.count', -1) do
      delete comment_tone_type_url(@comment_tone_type)
    end

    assert_redirected_to comment_tone_types_url
  end
end
