require 'test_helper'

class TipoventaControllerTest < ActionController::TestCase
  setup do
    @tipoventum = tipoventa(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipoventa)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipoventum" do
    assert_difference('Tipoventum.count') do
      post :create, tipoventum: { code: @tipoventum.code, nombre: @tipoventum.nombre }
    end

    assert_redirected_to tipoventum_path(assigns(:tipoventum))
  end

  test "should show tipoventum" do
    get :show, id: @tipoventum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipoventum
    assert_response :success
  end

  test "should update tipoventum" do
    patch :update, id: @tipoventum, tipoventum: { code: @tipoventum.code, nombre: @tipoventum.nombre }
    assert_redirected_to tipoventum_path(assigns(:tipoventum))
  end

  test "should destroy tipoventum" do
    assert_difference('Tipoventum.count', -1) do
      delete :destroy, id: @tipoventum
    end

    assert_redirected_to tipoventa_path
  end
end
