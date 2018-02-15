require 'test_helper'

class DestinosControllerTest < ActionController::TestCase
  setup do
    @destino = destinos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:destinos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create destino" do
    assert_difference('Destino.count') do
      post :create, destino: { code: @destino.code, name: @destino.name }
    end

    assert_redirected_to destino_path(assigns(:destino))
  end

  test "should show destino" do
    get :show, id: @destino
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @destino
    assert_response :success
  end

  test "should update destino" do
    patch :update, id: @destino, destino: { code: @destino.code, name: @destino.name }
    assert_redirected_to destino_path(assigns(:destino))
  end

  test "should destroy destino" do
    assert_difference('Destino.count', -1) do
      delete :destroy, id: @destino
    end

    assert_redirected_to destinos_path
  end
end
