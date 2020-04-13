require "application_system_test_case"

class TorneosTest < ApplicationSystemTestCase
  setup do
    @torneo = torneos(:one)
  end

  test "visiting the index" do
    visit torneos_url
    assert_selector "h1", text: "Torneos"
  end

  test "creating a Torneo" do
    visit torneos_url
    click_on "New Torneo"

    fill_in "Fecha fin", with: @torneo.fecha_fin
    fill_in "Fecha inicio", with: @torneo.fecha_inicio
    fill_in "Nombre", with: @torneo.nombre
    click_on "Create Torneo"

    assert_text "Torneo was successfully created"
    click_on "Back"
  end

  test "updating a Torneo" do
    visit torneos_url
    click_on "Edit", match: :first

    fill_in "Fecha fin", with: @torneo.fecha_fin
    fill_in "Fecha inicio", with: @torneo.fecha_inicio
    fill_in "Nombre", with: @torneo.nombre
    click_on "Update Torneo"

    assert_text "Torneo was successfully updated"
    click_on "Back"
  end

  test "destroying a Torneo" do
    visit torneos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Torneo was successfully destroyed"
  end
end
