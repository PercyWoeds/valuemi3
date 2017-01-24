require 'test_helper'

class NumerasControllerTest < ActionController::TestCase
  setup do
    @numera = numeras(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:numeras)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create numera" do
    assert_difference('Numera.count') do
      post :create, numera: { compro: @numera.compro, subdiario: @numera.subdiario }
    end

    assert_redirected_to numera_path(assigns(:numera))
  end

  test "should show numera" do
    get :show, id: @numera
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @numera
    assert_response :success
  end

  test "should update numera" do
    patch :update, id: @numera, numera: { compro: @numera.compro, subdiario: @numera.subdiario }
    assert_redirected_to numera_path(assigns(:numera))
  end

  test "should destroy numera" do
    assert_difference('Numera.count', -1) do
      delete :destroy, id: @numera
    end

    assert_redirected_to numeras_path
  end
end
