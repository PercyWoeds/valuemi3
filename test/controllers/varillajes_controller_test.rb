require 'test_helper'

class VarillajesControllerTest < ActionController::TestCase
  setup do
    @varillaje = varillajes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:varillajes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create varillaje" do
    assert_difference('Varillaje.count') do
      post :create, varillaje: { compras: @varillaje.compras, consumo: @varillaje.consumo, dife_dia: @varillaje.dife_dia, directo: @varillaje.directo, documento: @varillaje.documento, fecha: @varillaje.fecha, inicial: @varillaje.inicial, product_id: @varillaje.product_id, saldo: @varillaje.saldo, tanque_id: @varillaje.tanque_id, transfe: @varillaje.transfe, varilla: @varillaje.varilla }
    end

    assert_redirected_to varillaje_path(assigns(:varillaje))
  end

  test "should show varillaje" do
    get :show, id: @varillaje
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @varillaje
    assert_response :success
  end

  test "should update varillaje" do
    patch :update, id: @varillaje, varillaje: { compras: @varillaje.compras, consumo: @varillaje.consumo, dife_dia: @varillaje.dife_dia, directo: @varillaje.directo, documento: @varillaje.documento, fecha: @varillaje.fecha, inicial: @varillaje.inicial, product_id: @varillaje.product_id, saldo: @varillaje.saldo, tanque_id: @varillaje.tanque_id, transfe: @varillaje.transfe, varilla: @varillaje.varilla }
    assert_redirected_to varillaje_path(assigns(:varillaje))
  end

  test "should destroy varillaje" do
    assert_difference('Varillaje.count', -1) do
      delete :destroy, id: @varillaje
    end

    assert_redirected_to varillajes_path
  end
end
