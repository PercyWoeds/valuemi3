require 'test_helper'

class ParametersControllerTest < ActionController::TestCase
  setup do
    @parameter = parameters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:parameters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create parameter" do
    assert_difference('Parameter.count') do
      post :create, parameter: { code: @parameter.code, essalud: @parameter.essalud, fecha: @parameter.fecha, onp: @parameter.onp, sctr_1: @parameter.sctr_1, sctr_2: @parameter.sctr_2 }
    end

    assert_redirected_to parameter_path(assigns(:parameter))
  end

  test "should show parameter" do
    get :show, id: @parameter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @parameter
    assert_response :success
  end

  test "should update parameter" do
    patch :update, id: @parameter, parameter: { code: @parameter.code, essalud: @parameter.essalud, fecha: @parameter.fecha, onp: @parameter.onp, sctr_1: @parameter.sctr_1, sctr_2: @parameter.sctr_2 }
    assert_redirected_to parameter_path(assigns(:parameter))
  end

  test "should destroy parameter" do
    assert_difference('Parameter.count', -1) do
      delete :destroy, id: @parameter
    end

    assert_redirected_to parameters_path
  end
end
