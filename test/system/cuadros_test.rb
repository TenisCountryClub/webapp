require "application_system_test_case"

class CuadrosTest < ApplicationSystemTestCase
  setup do
    @cuadro = cuadros(:one)
  end

  test "visiting the index" do
    visit cuadros_url
    assert_selector "h1", text: "Cuadros"
  end

  test "creating a Cuadro" do
    visit cuadros_url
    click_on "New Cuadro"

    fill_in "Categorium", with: @cuadro.categorium_id
    fill_in "Etapa", with: @cuadro.etapa
    fill_in "Numero", with: @cuadro.numero
    click_on "Create Cuadro"

    assert_text "Cuadro was successfully created"
    click_on "Back"
  end

  test "updating a Cuadro" do
    visit cuadros_url
    click_on "Edit", match: :first

    fill_in "Categorium", with: @cuadro.categorium_id
    fill_in "Etapa", with: @cuadro.etapa
    fill_in "Numero", with: @cuadro.numero
    click_on "Update Cuadro"

    assert_text "Cuadro was successfully updated"
    click_on "Back"
  end

  test "destroying a Cuadro" do
    visit cuadros_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cuadro was successfully destroyed"
  end
end
