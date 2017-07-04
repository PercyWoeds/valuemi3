require 'test_helper'

class GastosControllerTest < ActionController::TestCase
  setup do
    @gasto = gastos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gastos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gasto" do
    assert_difference('Gasto.count') do
      post :create, gasto: { code: @gasto.code, codigo: @gasto.codigo, cuenta: @gasto.cuenta, descrip: @gasto.descrip }
    end

    assert_redirected_to gasto_path(assigns(:gasto))
  end

  test "should show gasto" do
    get :show, id: @gasto
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gasto
    assert_response :success
  end

  test "should update gasto" do
    patch :update, id: @gasto, gasto: { code: @gasto.code, codigo: @gasto.codigo, cuenta: @gasto.cuenta, descrip: @gasto.descrip }
    assert_redirected_to gasto_path(assigns(:gasto))
  end

  test "should destroy gasto" do
    assert_difference('Gasto.count', -1) do
      delete :destroy, id: @gasto
    end

    assert_redirected_to gastos_path
  end
end
