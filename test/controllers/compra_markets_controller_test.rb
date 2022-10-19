require 'test_helper'

class CompraMarketsControllerTest < ActionController::TestCase
  setup do
    @compra_market = compra_markets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:compra_markets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create compra_market" do
    assert_difference('CompraMarket.count') do
      post :create, compra_market: { IMPORTE_CONV: @compra_market.IMPORTE_CONV, cod_provdescuento: @compra_market.cod_provdescuento, preciosigv: @compra_market.preciosigv }
    end

    assert_redirected_to compra_market_path(assigns(:compra_market))
  end

  test "should show compra_market" do
    get :show, id: @compra_market
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @compra_market
    assert_response :success
  end

  test "should update compra_market" do
    patch :update, id: @compra_market, compra_market: { IMPORTE_CONV: @compra_market.IMPORTE_CONV, cod_provdescuento: @compra_market.cod_provdescuento, preciosigv: @compra_market.preciosigv }
    assert_redirected_to compra_market_path(assigns(:compra_market))
  end

  test "should destroy compra_market" do
    assert_difference('CompraMarket.count', -1) do
      delete :destroy, id: @compra_market
    end

    assert_redirected_to compra_markets_path
  end
end
