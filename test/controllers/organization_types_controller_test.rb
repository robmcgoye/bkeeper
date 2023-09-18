require "test_helper"

class OrganizationTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization_type = organization_types(:one)
  end

  test "should get index" do
    get organization_types_url
    assert_response :success
  end

  test "should get new" do
    get new_organization_type_url
    assert_response :success
  end

  test "should create organization_type" do
    assert_difference("OrganizationType.count") do
      post organization_types_url, params: { organization_type: {  } }
    end

    assert_redirected_to organization_type_url(OrganizationType.last)
  end

  test "should show organization_type" do
    get organization_type_url(@organization_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_organization_type_url(@organization_type)
    assert_response :success
  end

  test "should update organization_type" do
    patch organization_type_url(@organization_type), params: { organization_type: {  } }
    assert_redirected_to organization_type_url(@organization_type)
  end

  test "should destroy organization_type" do
    assert_difference("OrganizationType.count", -1) do
      delete organization_type_url(@organization_type)
    end

    assert_redirected_to organization_types_url
  end
end
