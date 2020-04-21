require 'test_helper'

class GrupoJugadorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @grupo_jugador = grupo_jugadors(:one)
  end

  test "should get index" do
    get grupo_jugadors_url
    assert_response :success
  end

  test "should get new" do
    get new_grupo_jugador_url
    assert_response :success
  end

  test "should create grupo_jugador" do
    assert_difference('GrupoJugador.count') do
      post grupo_jugadors_url, params: { grupo_jugador: { grupo_id: @grupo_jugador.grupo_id, jugador_id: @grupo_jugador.jugador_id, numero: @grupo_jugador.numero } }
    end

    assert_redirected_to grupo_jugador_url(GrupoJugador.last)
  end

  test "should show grupo_jugador" do
    get grupo_jugador_url(@grupo_jugador)
    assert_response :success
  end

  test "should get edit" do
    get edit_grupo_jugador_url(@grupo_jugador)
    assert_response :success
  end

  test "should update grupo_jugador" do
    patch grupo_jugador_url(@grupo_jugador), params: { grupo_jugador: { grupo_id: @grupo_jugador.grupo_id, jugador_id: @grupo_jugador.jugador_id, numero: @grupo_jugador.numero } }
    assert_redirected_to grupo_jugador_url(@grupo_jugador)
  end

  test "should destroy grupo_jugador" do
    assert_difference('GrupoJugador.count', -1) do
      delete grupo_jugador_url(@grupo_jugador)
    end

    assert_redirected_to grupo_jugadors_url
  end
end
