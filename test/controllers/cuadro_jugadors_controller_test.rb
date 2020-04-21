require 'test_helper'

class CuadroJugadorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cuadro_jugador = cuadro_jugadors(:one)
  end

  test "should get index" do
    get cuadro_jugadors_url
    assert_response :success
  end

  test "should get new" do
    get new_cuadro_jugador_url
    assert_response :success
  end

  test "should create cuadro_jugador" do
    assert_difference('CuadroJugador.count') do
      post cuadro_jugadors_url, params: { cuadro_jugador: { cuadro_id: @cuadro_jugador.cuadro_id, jugador_id: @cuadro_jugador.jugador_id, numero: @cuadro_jugador.numero } }
    end

    assert_redirected_to cuadro_jugador_url(CuadroJugador.last)
  end

  test "should show cuadro_jugador" do
    get cuadro_jugador_url(@cuadro_jugador)
    assert_response :success
  end

  test "should get edit" do
    get edit_cuadro_jugador_url(@cuadro_jugador)
    assert_response :success
  end

  test "should update cuadro_jugador" do
    patch cuadro_jugador_url(@cuadro_jugador), params: { cuadro_jugador: { cuadro_id: @cuadro_jugador.cuadro_id, jugador_id: @cuadro_jugador.jugador_id, numero: @cuadro_jugador.numero } }
    assert_redirected_to cuadro_jugador_url(@cuadro_jugador)
  end

  test "should destroy cuadro_jugador" do
    assert_difference('CuadroJugador.count', -1) do
      delete cuadro_jugador_url(@cuadro_jugador)
    end

    assert_redirected_to cuadro_jugadors_url
  end
end
