require 'test_helper'

class CcostosControllerTest < ActionController::TestCase
  setup do
    @ccosto = ccostos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ccostos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ccosto" do
    assert_difference('Ccosto.count') do
      post :create, ccosto: { code: @ccosto.code, comments: @ccosto.comments, name: @ccosto.name }
    end

    assert_redirected_to ccosto_path(assigns(:ccosto))
  end

  test "should show ccosto" do
    get :show, id: @ccosto
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ccosto
    assert_response :success
  end

  test "should update ccosto" do
    patch :update, id: @ccosto, ccosto: { code: @ccosto.code, comments: @ccosto.comments, name: @ccosto.name }
    assert_redirected_to ccosto_path(assigns(:ccosto))
  end

  test "should destroy ccosto" do
    assert_difference('Ccosto.count', -1) do
      delete :destroy, id: @ccosto
    end

    assert_redirected_to ccostos_path
  end
end
