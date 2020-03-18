require "application_system_test_case"

class LlavesTest < ApplicationSystemTestCase
  setup do
    @llafe = llaves(:one)
  end

  test "visiting the index" do
    visit llaves_url
    assert_selector "h1", text: "Llaves"
  end

  test "creating a Llave" do
    visit llaves_url
    click_on "New Llave"

    fill_in "Etapa", with: @llafe.etapa
    fill_in "Numero", with: @llafe.numero
    click_on "Create Llave"

    assert_text "Llave was successfully created"
    click_on "Back"
  end

  test "updating a Llave" do
    visit llaves_url
    click_on "Edit", match: :first

    fill_in "Etapa", with: @llafe.etapa
    fill_in "Numero", with: @llafe.numero
    click_on "Update Llave"

    assert_text "Llave was successfully updated"
    click_on "Back"
  end

  test "destroying a Llave" do
    visit llaves_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Llave was successfully destroyed"
  end
end
