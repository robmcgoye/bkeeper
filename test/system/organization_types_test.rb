require "application_system_test_case"

class OrganizationTypesTest < ApplicationSystemTestCase
  setup do
    @organization_type = organization_types(:one)
  end

  test "visiting the index" do
    visit organization_types_url
    assert_selector "h1", text: "Organization types"
  end

  test "should create organization type" do
    visit organization_types_url
    click_on "New organization type"

    click_on "Create Organization type"

    assert_text "Organization type was successfully created"
    click_on "Back"
  end

  test "should update Organization type" do
    visit organization_type_url(@organization_type)
    click_on "Edit this organization type", match: :first

    click_on "Update Organization type"

    assert_text "Organization type was successfully updated"
    click_on "Back"
  end

  test "should destroy Organization type" do
    visit organization_type_url(@organization_type)
    click_on "Destroy this organization type", match: :first

    assert_text "Organization type was successfully destroyed"
  end
end
