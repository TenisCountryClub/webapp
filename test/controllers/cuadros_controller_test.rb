require 'test_helper'

class CuadrosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cuadro = cuadros(:one)
  end

  test "should get index" do
    get cuadros_url
    assert_response :success
  end

  test "should get new" do
    get new_cuadro_url
    assert_response :success
  end

  test "should create cuadro" do
    assert_difference('Cuadro.count') do
      post cuadros_url, params: { cuadro: { categorium_id: @cuadro.categorium_id, etapa: @cuadro.etapa, numero: @cuadro.numero } }
    end

    assert_redirected_to cuadro_url(Cuadro.last)
  end

  test "should show cuadro" do
    get cuadro_url(@cuadro)
    assert_response :success
  end

  test "should get edit" do
    get edit_cuadro_url(@cuadro)
    assert_response :success
  end

  test "should update cuadro" do
    patch cuadro_url(@cuadro), params: { cuadro: { categorium_id: @cuadro.categorium_id, etapa: @cuadro.etapa, numero: @cuadro.numero } }
    assert_redirected_to cuadro_url(@cuadro)
  end

  test "should destroy cuadro" do
    assert_difference('Cuadro.count', -1) do
      delete cuadro_url(@cuadro)
    end

    assert_redirected_to cuadros_url
  end
end
