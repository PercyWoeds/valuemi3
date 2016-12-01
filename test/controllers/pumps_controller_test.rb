require 'test_helper'

class PumpsControllerTest < ActionController::TestCase
  setup do
    @pump = pumps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pumps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pump" do
    assert_difference('Pump.count') do
      post :create, pump: { date1: @pump.date1, employee_id: @pump.employee_id, fuel: @pump.fuel, gln: @pump.gln, le_ac_gln: @pump.le_ac_gln, le_an_gln: @pump.le_an_gln, price_buy: @pump.price_buy, price_sell: @pump.price_sell, product_id: @pump.product_id, pump01: @pump.pump01, tank_id: @pump.tank_id, turno: @pump.turno }
    end

    assert_redirected_to pump_path(assigns(:pump))
  end

  test "should show pump" do
    get :show, id: @pump
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pump
    assert_response :success
  end

  test "should update pump" do
    patch :update, id: @pump, pump: { date1: @pump.date1, employee_id: @pump.employee_id, fuel: @pump.fuel, gln: @pump.gln, le_ac_gln: @pump.le_ac_gln, le_an_gln: @pump.le_an_gln, price_buy: @pump.price_buy, price_sell: @pump.price_sell, product_id: @pump.product_id, pump01: @pump.pump01, tank_id: @pump.tank_id, turno: @pump.turno }
    assert_redirected_to pump_path(assigns(:pump))
  end

  test "should destroy pump" do
    assert_difference('Pump.count', -1) do
      delete :destroy, id: @pump
    end

    assert_redirected_to pumps_path
  end
end
