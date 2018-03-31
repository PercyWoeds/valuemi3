require 'test_helper'

class CreditosControllerTest < ActionController::TestCase
  setup do
    @credito = creditos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:creditos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create credito" do
    assert_difference('Credito.count') do
      post :create, credito: { code: @credito.code, nombre: @credito.nombre }
    end

    assert_redirected_to credito_path(assigns(:credito))
  end

  test "should show credito" do
    get :show, id: @credito
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @credito
    assert_response :success
  end

  test "should update credito" do
    patch :update, id: @credito, credito: { code: @credito.code, nombre: @credito.nombre }
    assert_redirected_to credito_path(assigns(:credito))
  end

  test "should destroy credito" do
    assert_difference('Credito.count', -1) do
      delete :destroy, id: @credito
    end

    assert_redirected_to creditos_path
  end
end
