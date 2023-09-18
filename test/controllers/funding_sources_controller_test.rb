require "test_helper"

class FundingSourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @funding_source = funding_sources(:one)
  end

  test "should get index" do
    get funding_sources_url
    assert_response :success
  end

  test "should get new" do
    get new_funding_source_url
    assert_response :success
  end

  test "should create funding_source" do
    assert_difference("FundingSource.count") do
      post funding_sources_url, params: { funding_source: {  } }
    end

    assert_redirected_to funding_source_url(FundingSource.last)
  end

  test "should show funding_source" do
    get funding_source_url(@funding_source)
    assert_response :success
  end

  test "should get edit" do
    get edit_funding_source_url(@funding_source)
    assert_response :success
  end

  test "should update funding_source" do
    patch funding_source_url(@funding_source), params: { funding_source: {  } }
    assert_redirected_to funding_source_url(@funding_source)
  end

  test "should destroy funding_source" do
    assert_difference("FundingSource.count", -1) do
      delete funding_source_url(@funding_source)
    end

    assert_redirected_to funding_sources_url
  end
end
