require "application_system_test_case"

class GrupoJugadorsTest < ApplicationSystemTestCase
  setup do
    @grupo_jugador = grupo_jugadors(:one)
  end

  test "visiting the index" do
    visit grupo_jugadors_url
    assert_selector "h1", text: "Grupo Jugadors"
  end

  test "creating a Grupo jugador" do
    visit grupo_jugadors_url
    click_on "New Grupo Jugador"

    fill_in "Grupo", with: @grupo_jugador.grupo_id
    fill_in "Jugador", with: @grupo_jugador.jugador_id
    fill_in "Numero", with: @grupo_jugador.numero
    click_on "Create Grupo jugador"

    assert_text "Grupo jugador was successfully created"
    click_on "Back"
  end

  test "updating a Grupo jugador" do
    visit grupo_jugadors_url
    click_on "Edit", match: :first

    fill_in "Grupo", with: @grupo_jugador.grupo_id
    fill_in "Jugador", with: @grupo_jugador.jugador_id
    fill_in "Numero", with: @grupo_jugador.numero
    click_on "Update Grupo jugador"

    assert_text "Grupo jugador was successfully updated"
    click_on "Back"
  end

  test "destroying a Grupo jugador" do
    visit grupo_jugadors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Grupo jugador was successfully destroyed"
  end
end
