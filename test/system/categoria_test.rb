require "application_system_test_case"

class CategoriaTest < ApplicationSystemTestCase
  setup do
    @categorium = categoria(:one)
  end

  test "visiting the index" do
    visit categoria_url
    assert_selector "h1", text: "Categoria"
  end

  test "creating a Categorium" do
    visit categoria_url
    click_on "New Categorium"

    fill_in "Nombre", with: @categorium.nombre
    fill_in "Numero grupos", with: @categorium.numero_grupos
    fill_in "Numero jugadores", with: @categorium.numero_jugadores
    fill_in "Numero jugadores grupo", with: @categorium.numero_jugadores_grupo
    fill_in "Tipo", with: @categorium.tipo
    fill_in "Torneo", with: @categorium.torneo_id
    click_on "Create Categorium"

    assert_text "Categorium was successfully created"
    click_on "Back"
  end

  test "updating a Categorium" do
    visit categoria_url
    click_on "Edit", match: :first

    fill_in "Nombre", with: @categorium.nombre
    fill_in "Numero grupos", with: @categorium.numero_grupos
    fill_in "Numero jugadores", with: @categorium.numero_jugadores
    fill_in "Numero jugadores grupo", with: @categorium.numero_jugadores_grupo
    fill_in "Tipo", with: @categorium.tipo
    fill_in "Torneo", with: @categorium.torneo_id
    click_on "Update Categorium"

    assert_text "Categorium was successfully updated"
    click_on "Back"
  end

  test "destroying a Categorium" do
    visit categoria_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Categorium was successfully destroyed"
  end
end
