require "test_helper"

class FoundationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @foundation = foundations(:one)
  end

  test "should get index" do
    get foundations_url
    assert_response :success
  end

  test "should get new" do
    get new_foundation_url
    assert_response :success
  end

  test "should create foundation" do
    assert_difference("Foundation.count") do
      post foundations_url, params: { foundation: { long_name: @foundation.long_name, short_name: @foundation.short_name } }
    end

    assert_redirected_to foundation_url(Foundation.last)
  end

  test "should show foundation" do
    get foundation_url(@foundation)
    assert_response :success
  end

  test "should get edit" do
    get edit_foundation_url(@foundation)
    assert_response :success
  end

  test "should update foundation" do
    patch foundation_url(@foundation), params: { foundation: { long_name: @foundation.long_name, short_name: @foundation.short_name } }
    assert_redirected_to foundation_url(@foundation)
  end

  test "should destroy foundation" do
    assert_difference("Foundation.count", -1) do
      delete foundation_url(@foundation)
    end

    assert_redirected_to foundations_url
  end
end
