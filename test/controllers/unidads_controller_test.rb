require 'test_helper'

class UnidadsControllerTest < ActionController::TestCase
  setup do
    @unidad = unidads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:unidads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create unidad" do
    assert_difference('Unidad.count') do
      post :create, unidad: { descrip: @unidad.descrip, valorconversion: @unidad.valorconversion }
    end

    assert_redirected_to unidad_path(assigns(:unidad))
  end

  test "should show unidad" do
    get :show, id: @unidad
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @unidad
    assert_response :success
  end

  test "should update unidad" do
    patch :update, id: @unidad, unidad: { descrip: @unidad.descrip, valorconversion: @unidad.valorconversion }
    assert_redirected_to unidad_path(assigns(:unidad))
  end

  test "should destroy unidad" do
    assert_difference('Unidad.count', -1) do
      delete :destroy, id: @unidad
    end

    assert_redirected_to unidads_path
  end
end
