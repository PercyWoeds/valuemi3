require 'test_helper'

class TipofaltantesControllerTest < ActionController::TestCase
  setup do
    @tipofaltante = tipofaltantes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipofaltantes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipofaltante" do
    assert_difference('Tipofaltante.count') do
      post :create, tipofaltante: { code: @tipofaltante.code, descrip: @tipofaltante.descrip }
    end

    assert_redirected_to tipofaltante_path(assigns(:tipofaltante))
  end

  test "should show tipofaltante" do
    get :show, id: @tipofaltante
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipofaltante
    assert_response :success
  end

  test "should update tipofaltante" do
    patch :update, id: @tipofaltante, tipofaltante: { code: @tipofaltante.code, descrip: @tipofaltante.descrip }
    assert_redirected_to tipofaltante_path(assigns(:tipofaltante))
  end

  test "should destroy tipofaltante" do
    assert_difference('Tipofaltante.count', -1) do
      delete :destroy, id: @tipofaltante
    end

    assert_redirected_to tipofaltantes_path
  end
end
