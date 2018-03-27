require 'test_helper'

class AfericionsControllerTest < ActionController::TestCase
  setup do
    @afericion = afericions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:afericions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create afericion" do
    assert_difference('Afericion.count') do
      post :create, afericion: { concepto: @afericion.concepto, documento: @afericion.documento, employee_id: @afericion.employee_id, fecha: @afericion.fecha, importe: @afericion.importe, quantity: @afericion.quantity, tanque_id: @afericion.tanque_id, turno: @afericion.turno }
    end

    assert_redirected_to afericion_path(assigns(:afericion))
  end

  test "should show afericion" do
    get :show, id: @afericion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @afericion
    assert_response :success
  end

  test "should update afericion" do
    patch :update, id: @afericion, afericion: { concepto: @afericion.concepto, documento: @afericion.documento, employee_id: @afericion.employee_id, fecha: @afericion.fecha, importe: @afericion.importe, quantity: @afericion.quantity, tanque_id: @afericion.tanque_id, turno: @afericion.turno }
    assert_redirected_to afericion_path(assigns(:afericion))
  end

  test "should destroy afericion" do
    assert_difference('Afericion.count', -1) do
      delete :destroy, id: @afericion
    end

    assert_redirected_to afericions_path
  end
end
