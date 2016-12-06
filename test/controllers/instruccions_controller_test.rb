require 'test_helper'

class InstruccionsControllerTest < ActionController::TestCase
  setup do
    @instruccion = instruccions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:instruccions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create instruccion" do
    assert_difference('Instruccion.count') do
      post :create, instruccion: { description1: @instruccion.description1, description2: @instruccion.description2, description3: @instruccion.description3, description4: @instruccion.description4 }
    end

    assert_redirected_to instruccion_path(assigns(:instruccion))
  end

  test "should show instruccion" do
    get :show, id: @instruccion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @instruccion
    assert_response :success
  end

  test "should update instruccion" do
    patch :update, id: @instruccion, instruccion: { description1: @instruccion.description1, description2: @instruccion.description2, description3: @instruccion.description3, description4: @instruccion.description4 }
    assert_redirected_to instruccion_path(assigns(:instruccion))
  end

  test "should destroy instruccion" do
    assert_difference('Instruccion.count', -1) do
      delete :destroy, id: @instruccion
    end

    assert_redirected_to instruccions_path
  end
end
