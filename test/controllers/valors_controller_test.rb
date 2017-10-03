require 'test_helper'

class ValorsControllerTest < ActionController::TestCase
  setup do
    @valor = valors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:valors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create valor" do
    assert_difference('Valor.count') do
      post :create, valor: { comments: @valor.comments, name: @valor.name }
    end

    assert_redirected_to valor_path(assigns(:valor))
  end

  test "should show valor" do
    get :show, id: @valor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @valor
    assert_response :success
  end

  test "should update valor" do
    patch :update, id: @valor, valor: { comments: @valor.comments, name: @valor.name }
    assert_redirected_to valor_path(assigns(:valor))
  end

  test "should destroy valor" do
    assert_difference('Valor.count', -1) do
      delete :destroy, id: @valor
    end

    assert_redirected_to valors_path
  end
end
