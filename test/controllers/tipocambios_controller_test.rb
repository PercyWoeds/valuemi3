require 'test_helper'

class TipocambiosControllerTest < ActionController::TestCase
  setup do
    @tipocambio = tipocambios(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipocambios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipocambio" do
    assert_difference('Tipocambio.count') do
      post :create, tipocambio: { compra: @tipocambio.compra, dia: @tipocambio.dia, venta: @tipocambio.venta }
    end

    assert_redirected_to tipocambio_path(assigns(:tipocambio))
  end

  test "should show tipocambio" do
    get :show, id: @tipocambio
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipocambio
    assert_response :success
  end

  test "should update tipocambio" do
    patch :update, id: @tipocambio, tipocambio: { compra: @tipocambio.compra, dia: @tipocambio.dia, venta: @tipocambio.venta }
    assert_redirected_to tipocambio_path(assigns(:tipocambio))
  end

  test "should destroy tipocambio" do
    assert_difference('Tipocambio.count', -1) do
      delete :destroy, id: @tipocambio
    end

    assert_redirected_to tipocambios_path
  end
end
