require 'test_helper'

class JugadorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jugador = jugadors(:one)
  end

  test "should get index" do
    get jugadors_url
    assert_response :success
  end

  test "should get new" do
    get new_jugador_url
    assert_response :success
  end

  test "should create jugador" do
    assert_difference('Jugador.count') do
      post jugadors_url, params: { jugador: { club_asociacion: @jugador.club_asociacion, edad: @jugador.edad, fecha_inscripcion: @jugador.fecha_inscripcion, nombre: @jugador.nombre, numero: @jugador.numero, ranking: @jugador.ranking, status: @jugador.status } }
    end

    assert_redirected_to jugador_url(Jugador.last)
  end

  test "should show jugador" do
    get jugador_url(@jugador)
    assert_response :success
  end

  test "should get edit" do
    get edit_jugador_url(@jugador)
    assert_response :success
  end

  test "should update jugador" do
    patch jugador_url(@jugador), params: { jugador: { club_asociacion: @jugador.club_asociacion, edad: @jugador.edad, fecha_inscripcion: @jugador.fecha_inscripcion, nombre: @jugador.nombre, numero: @jugador.numero, ranking: @jugador.ranking, status: @jugador.status } }
    assert_redirected_to jugador_url(@jugador)
  end

  test "should destroy jugador" do
    assert_difference('Jugador.count', -1) do
      delete jugador_url(@jugador)
    end

    assert_redirected_to jugadors_url
  end
end
