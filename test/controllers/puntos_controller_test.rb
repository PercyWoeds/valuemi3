require 'test_helper'

class PuntosControllerTest < ActionController::TestCase
  setup do
    @punto = puntos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:puntos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create punto" do
    assert_difference('Punto.count') do
      post :create, punto: { name: @punto.name }
    end

    assert_redirected_to punto_path(assigns(:punto))
  end

  test "should show punto" do
    get :show, id: @punto
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @punto
    assert_response :success
  end

  test "should update punto" do
    patch :update, id: @punto, punto: { name: @punto.name }
    assert_redirected_to punto_path(assigns(:punto))
  end

  test "should destroy punto" do
    assert_difference('Punto.count', -1) do
      delete :destroy, id: @punto
    end

    assert_redirected_to puntos_path
  end
end
