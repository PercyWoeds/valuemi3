require 'test_helper'

class DevolsControllerTest < ActionController::TestCase
  setup do
    @devol = devols(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:devols)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create devol" do
    assert_difference('Devol.count') do
      post :create, devol: { cod_prod: @devol.cod_prod, documento: @devol.documento, fecha: @devol.fecha, observa: @devol.observa }
    end

    assert_redirected_to devol_path(assigns(:devol))
  end

  test "should show devol" do
    get :show, id: @devol
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @devol
    assert_response :success
  end

  test "should update devol" do
    patch :update, id: @devol, devol: { cod_prod: @devol.cod_prod, documento: @devol.documento, fecha: @devol.fecha, observa: @devol.observa }
    assert_redirected_to devol_path(assigns(:devol))
  end

  test "should destroy devol" do
    assert_difference('Devol.count', -1) do
      delete :destroy, id: @devol
    end

    assert_redirected_to devols_path
  end
end
