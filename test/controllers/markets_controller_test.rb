require 'test_helper'

class MarketsControllerTest < ActionController::TestCase
  setup do
    @market = markets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:markets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create market" do
    assert_difference('Market.count') do
      post :create, market: { caja: @market.caja, cantidad: @market.cantidad, cod_cli: @market.cod_cli, cod_dep: @market.cod_dep, cod_emp: @market.cod_emp, cod_lin: @market.cod_lin, cod_prod: @market.cod_prod, cod_prod: @market.cod_prod, cod_tar: @market.cod_tar, dolar: @market.dolar, dolares: @market.dolares, fecha: @market.fecha, fpago: @market.fpago, igv: @market.igv, importe: @market.importe, margen: @market.margen, numero: @market.numero, odometro: @market.odometro, order_id: @market.order_id, placa: @market.placa, precio1: @market.precio1, precio: @market.precio, ruc: @market.ruc, serie: @market.serie, td: @market.td, turno: @market.turno }
    end

    assert_redirected_to market_path(assigns(:market))
  end

  test "should show market" do
    get :show, id: @market
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @market
    assert_response :success
  end

  test "should update market" do
    patch :update, id: @market, market: { caja: @market.caja, cantidad: @market.cantidad, cod_cli: @market.cod_cli, cod_dep: @market.cod_dep, cod_emp: @market.cod_emp, cod_lin: @market.cod_lin, cod_prod: @market.cod_prod, cod_prod: @market.cod_prod, cod_tar: @market.cod_tar, dolar: @market.dolar, dolares: @market.dolares, fecha: @market.fecha, fpago: @market.fpago, igv: @market.igv, importe: @market.importe, margen: @market.margen, numero: @market.numero, odometro: @market.odometro, order_id: @market.order_id, placa: @market.placa, precio1: @market.precio1, precio: @market.precio, ruc: @market.ruc, serie: @market.serie, td: @market.td, turno: @market.turno }
    assert_redirected_to market_path(assigns(:market))
  end

  test "should destroy market" do
    assert_difference('Market.count', -1) do
      delete :destroy, id: @market
    end

    assert_redirected_to markets_path
  end
end
