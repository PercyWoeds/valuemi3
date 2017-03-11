require 'test_helper'

class CegresosControllerTest < ActionController::TestCase
  setup do
    @cegreso = cegresos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cegresos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cegreso" do
    assert_difference('Cegreso.count') do
      post :create, cegreso: { descrip: @cegreso.descrip, employee_id: @cegreso.employee_id, fecha1: @cegreso.fecha1, fecha2: @cegreso.fecha2, importe: @cegreso.importe, moneda_id: @cegreso.moneda_id, observa: @cegreso.observa, transportorder_id: @cegreso.transportorder_id }
    end

    assert_redirected_to cegreso_path(assigns(:cegreso))
  end

  test "should show cegreso" do
    get :show, id: @cegreso
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cegreso
    assert_response :success
  end

  test "should update cegreso" do
    patch :update, id: @cegreso, cegreso: { descrip: @cegreso.descrip, employee_id: @cegreso.employee_id, fecha1: @cegreso.fecha1, fecha2: @cegreso.fecha2, importe: @cegreso.importe, moneda_id: @cegreso.moneda_id, observa: @cegreso.observa, transportorder_id: @cegreso.transportorder_id }
    assert_redirected_to cegreso_path(assigns(:cegreso))
  end

  test "should destroy cegreso" do
    assert_difference('Cegreso.count', -1) do
      delete :destroy, id: @cegreso
    end

    assert_redirected_to cegresos_path
  end
end
