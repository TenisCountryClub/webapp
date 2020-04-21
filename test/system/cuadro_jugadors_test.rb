require "application_system_test_case"

class CuadroJugadorsTest < ApplicationSystemTestCase
  setup do
    @cuadro_jugador = cuadro_jugadors(:one)
  end

  test "visiting the index" do
    visit cuadro_jugadors_url
    assert_selector "h1", text: "Cuadro Jugadors"
  end

  test "creating a Cuadro jugador" do
    visit cuadro_jugadors_url
    click_on "New Cuadro Jugador"

    fill_in "Cuadro", with: @cuadro_jugador.cuadro_id
    fill_in "Jugador", with: @cuadro_jugador.jugador_id
    fill_in "Numero", with: @cuadro_jugador.numero
    click_on "Create Cuadro jugador"

    assert_text "Cuadro jugador was successfully created"
    click_on "Back"
  end

  test "updating a Cuadro jugador" do
    visit cuadro_jugadors_url
    click_on "Edit", match: :first

    fill_in "Cuadro", with: @cuadro_jugador.cuadro_id
    fill_in "Jugador", with: @cuadro_jugador.jugador_id
    fill_in "Numero", with: @cuadro_jugador.numero
    click_on "Update Cuadro jugador"

    assert_text "Cuadro jugador was successfully updated"
    click_on "Back"
  end

  test "destroying a Cuadro jugador" do
    visit cuadro_jugadors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cuadro jugador was successfully destroyed"
  end
end
