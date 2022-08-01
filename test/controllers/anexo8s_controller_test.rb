require 'test_helper'

class Anexo8sControllerTest < ActionController::TestCase
  setup do
    @anexo8 = anexo8s(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:anexo8s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create anexo8" do
    assert_difference('Anexo8.count') do
      post :create, anexo8: { code: @anexo8.code, code_nube: @anexo8.code_nube, name: @anexo8.name }
    end

    assert_redirected_to anexo8_path(assigns(:anexo8))
  end

  test "should show anexo8" do
    get :show, id: @anexo8
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @anexo8
    assert_response :success
  end

  test "should update anexo8" do
    patch :update, id: @anexo8, anexo8: { code: @anexo8.code, code_nube: @anexo8.code_nube, name: @anexo8.name }
    assert_redirected_to anexo8_path(assigns(:anexo8))
  end

  test "should destroy anexo8" do
    assert_difference('Anexo8.count', -1) do
      delete :destroy, id: @anexo8
    end

    assert_redirected_to anexo8s_path
  end
end
