require 'test_helper'

class VentaislasControllerTest < ActionController::TestCase
  setup do
    @ventaisla = ventaislas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ventaislas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ventaisla" do
    assert_difference('Ventaisla.count') do
      post :create, ventaisla: { employee_id: @ventaisla.employee_id, fecha: @ventaisla.fecha, galones: @ventaisla.galones, importe: @ventaisla.importe, le_ac_gln: @ventaisla.le_ac_gln, le_an_gln: @ventaisla.le_an_gln, precio_ven: @ventaisla.precio_ven, pump_id: @ventaisla.pump_id, turno: @ventaisla.turno }
    end

    assert_redirected_to ventaisla_path(assigns(:ventaisla))
  end

  test "should show ventaisla" do
    get :show, id: @ventaisla
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ventaisla
    assert_response :success
  end

  test "should update ventaisla" do
    patch :update, id: @ventaisla, ventaisla: { employee_id: @ventaisla.employee_id, fecha: @ventaisla.fecha, galones: @ventaisla.galones, importe: @ventaisla.importe, le_ac_gln: @ventaisla.le_ac_gln, le_an_gln: @ventaisla.le_an_gln, precio_ven: @ventaisla.precio_ven, pump_id: @ventaisla.pump_id, turno: @ventaisla.turno }
    assert_redirected_to ventaisla_path(assigns(:ventaisla))
  end

  test "should destroy ventaisla" do
    assert_difference('Ventaisla.count', -1) do
      delete :destroy, id: @ventaisla
    end

    assert_redirected_to ventaislas_path
  end
end
