require 'test_helper'

class TanquesControllerTest < ActionController::TestCase
  setup do
    @tanque = tanques(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tanques)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tanque" do
    assert_difference('Tanque.count') do
      post :create, tanque: { code: @tanque.code, product_id: @tanque.product_id, saldo_inicial: @tanque.saldo_inicial, varilla: @tanque.varilla }
    end

    assert_redirected_to tanque_path(assigns(:tanque))
  end

  test "should show tanque" do
    get :show, id: @tanque
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tanque
    assert_response :success
  end

  test "should update tanque" do
    patch :update, id: @tanque, tanque: { code: @tanque.code, product_id: @tanque.product_id, saldo_inicial: @tanque.saldo_inicial, varilla: @tanque.varilla }
    assert_redirected_to tanque_path(assigns(:tanque))
  end

  test "should destroy tanque" do
    assert_difference('Tanque.count', -1) do
      delete :destroy, id: @tanque
    end

    assert_redirected_to tanques_path
  end
end
