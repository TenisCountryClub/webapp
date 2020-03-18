require 'test_helper'

class LlavesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @llafe = llaves(:one)
  end

  test "should get index" do
    get llaves_url
    assert_response :success
  end

  test "should get new" do
    get new_llafe_url
    assert_response :success
  end

  test "should create llafe" do
    assert_difference('Llave.count') do
      post llaves_url, params: { llafe: { etapa: @llafe.etapa, numero: @llafe.numero } }
    end

    assert_redirected_to llafe_url(Llave.last)
  end

  test "should show llafe" do
    get llafe_url(@llafe)
    assert_response :success
  end

  test "should get edit" do
    get edit_llafe_url(@llafe)
    assert_response :success
  end

  test "should update llafe" do
    patch llafe_url(@llafe), params: { llafe: { etapa: @llafe.etapa, numero: @llafe.numero } }
    assert_redirected_to llafe_url(@llafe)
  end

  test "should destroy llafe" do
    assert_difference('Llave.count', -1) do
      delete llafe_url(@llafe)
    end

    assert_redirected_to llaves_url
  end
end
