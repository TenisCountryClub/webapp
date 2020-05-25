require "application_system_test_case"

class PartidosTest < ApplicationSystemTestCase
  setup do
    @partido = partidos(:one)
  end

  test "visiting the index" do
    visit partidos_url
    assert_selector "h1", text: "Partidos"
  end

  test "creating a Partido" do
    visit partidos_url
    click_on "New Partido"

    fill_in "Cuadro", with: @partido.cuadro_id
    fill_in "Grupo", with: @partido.grupo_id
    fill_in "Hora fin", with: @partido.hora_fin
    fill_in "Hora inicio", with: @partido.hora_inicio
    fill_in "Jugador dos", with: @partido.jugador_dos_id
    fill_in "Jugador uno", with: @partido.jugador_uno_id
    click_on "Create Partido"

    assert_text "Partido was successfully created"
    click_on "Back"
  end

  test "updating a Partido" do
    visit partidos_url
    click_on "Edit", match: :first

    fill_in "Cuadro", with: @partido.cuadro_id
    fill_in "Grupo", with: @partido.grupo_id
    fill_in "Hora fin", with: @partido.hora_fin
    fill_in "Hora inicio", with: @partido.hora_inicio
    fill_in "Jugador dos", with: @partido.jugador_dos_id
    fill_in "Jugador uno", with: @partido.jugador_uno_id
    click_on "Update Partido"

    assert_text "Partido was successfully updated"
    click_on "Back"
  end

  test "destroying a Partido" do
    visit partidos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Partido was successfully destroyed"
  end
end
