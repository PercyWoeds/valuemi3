require 'test_helper'

class TanksControllerTest < ActionController::TestCase
  setup do
    @tank = tanks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tanks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tank" do
    assert_difference('Tank.count') do
      post :create, tank: { code: @tank.code, product_id: @tank.product_id, product_id: @tank.product_id, saldo_inicial: @tank.saldo_inicial, varilla: @tank.varilla }
    end

    assert_redirected_to tank_path(assigns(:tank))
  end

  test "should show tank" do
    get :show, id: @tank
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tank
    assert_response :success
  end

  test "should update tank" do
    patch :update, id: @tank, tank: { code: @tank.code, product_id: @tank.product_id, product_id: @tank.product_id, saldo_inicial: @tank.saldo_inicial, varilla: @tank.varilla }
    assert_redirected_to tank_path(assigns(:tank))
  end

  test "should destroy tank" do
    assert_difference('Tank.count', -1) do
      delete :destroy, id: @tank
    end

    assert_redirected_to tanks_path
  end
end
