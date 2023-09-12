require "application_system_test_case"

class FoundationsTest < ApplicationSystemTestCase
  setup do
    @foundation = foundations(:one)
  end

  test "visiting the index" do
    visit foundations_url
    assert_selector "h1", text: "Foundations"
  end

  test "should create foundation" do
    visit foundations_url
    click_on "New foundation"

    fill_in "Long name", with: @foundation.long_name
    fill_in "Short name", with: @foundation.short_name
    click_on "Create Foundation"

    assert_text "Foundation was successfully created"
    click_on "Back"
  end

  test "should update Foundation" do
    visit foundation_url(@foundation)
    click_on "Edit this foundation", match: :first

    fill_in "Long name", with: @foundation.long_name
    fill_in "Short name", with: @foundation.short_name
    click_on "Update Foundation"

    assert_text "Foundation was successfully updated"
    click_on "Back"
  end

  test "should destroy Foundation" do
    visit foundation_url(@foundation)
    click_on "Destroy this foundation", match: :first

    assert_text "Foundation was successfully destroyed"
  end
end
