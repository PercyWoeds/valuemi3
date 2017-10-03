require 'test_helper'

class TipotrabajadorsControllerTest < ActionController::TestCase
  setup do
    @tipotrabajador = tipotrabajadors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipotrabajadors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipotrabajador" do
    assert_difference('Tipotrabajador.count') do
      post :create, tipotrabajador: { code: @tipotrabajador.code, name: @tipotrabajador.name }
    end

    assert_redirected_to tipotrabajador_path(assigns(:tipotrabajador))
  end

  test "should show tipotrabajador" do
    get :show, id: @tipotrabajador
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipotrabajador
    assert_response :success
  end

  test "should update tipotrabajador" do
    patch :update, id: @tipotrabajador, tipotrabajador: { code: @tipotrabajador.code, name: @tipotrabajador.name }
    assert_redirected_to tipotrabajador_path(assigns(:tipotrabajador))
  end

  test "should destroy tipotrabajador" do
    assert_difference('Tipotrabajador.count', -1) do
      delete :destroy, id: @tipotrabajador
    end

    assert_redirected_to tipotrabajadors_path
  end
end
