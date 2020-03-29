require "application_system_test_case"

class JugadorsTest < ApplicationSystemTestCase
  setup do
    @jugador = jugadors(:one)
  end

  test "visiting the index" do
    visit jugadors_url
    assert_selector "h1", text: "Jugadors"
  end

  test "creating a Jugador" do
    visit jugadors_url
    click_on "New Jugador"

    fill_in "Club asociacion", with: @jugador.club_asociacion
    fill_in "Edad", with: @jugador.edad
    fill_in "Fecha inscripcion", with: @jugador.fecha_inscripcion
    fill_in "Nombre", with: @jugador.nombre
    fill_in "Numero", with: @jugador.numero
    fill_in "Ranking", with: @jugador.ranking
    fill_in "Status", with: @jugador.status
    click_on "Create Jugador"

    assert_text "Jugador was successfully created"
    click_on "Back"
  end

  test "updating a Jugador" do
    visit jugadors_url
    click_on "Edit", match: :first

    fill_in "Club asociacion", with: @jugador.club_asociacion
    fill_in "Edad", with: @jugador.edad
    fill_in "Fecha inscripcion", with: @jugador.fecha_inscripcion
    fill_in "Nombre", with: @jugador.nombre
    fill_in "Numero", with: @jugador.numero
    fill_in "Ranking", with: @jugador.ranking
    fill_in "Status", with: @jugador.status
    click_on "Update Jugador"

    assert_text "Jugador was successfully updated"
    click_on "Back"
  end

  test "destroying a Jugador" do
    visit jugadors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Jugador was successfully destroyed"
  end
end
