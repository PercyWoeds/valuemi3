require 'test_helper'

class GradoInstruccionsControllerTest < ActionController::TestCase
  setup do
    @grado_instruccion = grado_instruccions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grado_instruccions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grado_instruccion" do
    assert_difference('GradoInstruccion.count') do
      post :create, grado_instruccion: { code: @grado_instruccion.code, name: @grado_instruccion.name }
    end

    assert_redirected_to grado_instruccion_path(assigns(:grado_instruccion))
  end

  test "should show grado_instruccion" do
    get :show, id: @grado_instruccion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @grado_instruccion
    assert_response :success
  end

  test "should update grado_instruccion" do
    patch :update, id: @grado_instruccion, grado_instruccion: { code: @grado_instruccion.code, name: @grado_instruccion.name }
    assert_redirected_to grado_instruccion_path(assigns(:grado_instruccion))
  end

  test "should destroy grado_instruccion" do
    assert_difference('GradoInstruccion.count', -1) do
      delete :destroy, id: @grado_instruccion
    end

    assert_redirected_to grado_instruccions_path
  end
end
