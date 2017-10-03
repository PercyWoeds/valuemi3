require 'test_helper'

class OcupacionsControllerTest < ActionController::TestCase
  setup do
    @ocupacion = ocupacions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ocupacions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ocupacion" do
    assert_difference('Ocupacion.count') do
      post :create, ocupacion: { AddOcupacionToEmployee: @ocupacion.AddOcupacionToEmployee, code: @ocupacion.code, name: @ocupacion.name }
    end

    assert_redirected_to ocupacion_path(assigns(:ocupacion))
  end

  test "should show ocupacion" do
    get :show, id: @ocupacion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ocupacion
    assert_response :success
  end

  test "should update ocupacion" do
    patch :update, id: @ocupacion, ocupacion: { AddOcupacionToEmployee: @ocupacion.AddOcupacionToEmployee, code: @ocupacion.code, name: @ocupacion.name }
    assert_redirected_to ocupacion_path(assigns(:ocupacion))
  end

  test "should destroy ocupacion" do
    assert_difference('Ocupacion.count', -1) do
      delete :destroy, id: @ocupacion
    end

    assert_redirected_to ocupacions_path
  end
end
