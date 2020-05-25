require 'test_helper'

class PartidosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @partido = partidos(:one)
  end

  test "should get index" do
    get partidos_url
    assert_response :success
  end

  test "should get new" do
    get new_partido_url
    assert_response :success
  end

  test "should create partido" do
    assert_difference('Partido.count') do
      post partidos_url, params: { partido: { cuadro_id: @partido.cuadro_id, grupo_id: @partido.grupo_id, hora_fin: @partido.hora_fin, hora_inicio: @partido.hora_inicio, jugador_dos_id: @partido.jugador_dos_id, jugador_uno_id: @partido.jugador_uno_id } }
    end

    assert_redirected_to partido_url(Partido.last)
  end

  test "should show partido" do
    get partido_url(@partido)
    assert_response :success
  end

  test "should get edit" do
    get edit_partido_url(@partido)
    assert_response :success
  end

  test "should update partido" do
    patch partido_url(@partido), params: { partido: { cuadro_id: @partido.cuadro_id, grupo_id: @partido.grupo_id, hora_fin: @partido.hora_fin, hora_inicio: @partido.hora_inicio, jugador_dos_id: @partido.jugador_dos_id, jugador_uno_id: @partido.jugador_uno_id } }
    assert_redirected_to partido_url(@partido)
  end

  test "should destroy partido" do
    assert_difference('Partido.count', -1) do
      delete partido_url(@partido)
    end

    assert_redirected_to partidos_url
  end
end
