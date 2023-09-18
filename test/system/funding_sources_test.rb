require "application_system_test_case"

class FundingSourcesTest < ApplicationSystemTestCase
  setup do
    @funding_source = funding_sources(:one)
  end

  test "visiting the index" do
    visit funding_sources_url
    assert_selector "h1", text: "Funding sources"
  end

  test "should create funding source" do
    visit funding_sources_url
    click_on "New funding source"

    click_on "Create Funding source"

    assert_text "Funding source was successfully created"
    click_on "Back"
  end

  test "should update Funding source" do
    visit funding_source_url(@funding_source)
    click_on "Edit this funding source", match: :first

    click_on "Update Funding source"

    assert_text "Funding source was successfully updated"
    click_on "Back"
  end

  test "should destroy Funding source" do
    visit funding_source_url(@funding_source)
    click_on "Destroy this funding source", match: :first

    assert_text "Funding source was successfully destroyed"
  end
end
