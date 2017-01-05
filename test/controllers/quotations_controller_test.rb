require 'test_helper'

class QuotationsControllerTest < ActionController::TestCase
  setup do
    @quotation = quotations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quotations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quotation" do
    assert_difference('Quotation.count') do
      post :create, quotation: { carga: @quotation.carga, code: @quotation.code, company_id: @quotation.company_id, condiciones: @quotation.condiciones, customer_id: @quotation.customer_id, division_id: @quotation.division_id, fecha1: @quotation.fecha1, firma_id: @quotation.firma_id, importe: @quotation.importe, location_id: @quotation.location_id, punto_id: @quotation.punto_id, respon: @quotation.respon, seguro: @quotation.seguro, tipo_unidad: @quotation.tipo_unidad }
    end

    assert_redirected_to quotation_path(assigns(:quotation))
  end

  test "should show quotation" do
    get :show, id: @quotation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quotation
    assert_response :success
  end

  test "should update quotation" do
    patch :update, id: @quotation, quotation: { carga: @quotation.carga, code: @quotation.code, company_id: @quotation.company_id, condiciones: @quotation.condiciones, customer_id: @quotation.customer_id, division_id: @quotation.division_id, fecha1: @quotation.fecha1, firma_id: @quotation.firma_id, importe: @quotation.importe, location_id: @quotation.location_id, punto_id: @quotation.punto_id, respon: @quotation.respon, seguro: @quotation.seguro, tipo_unidad: @quotation.tipo_unidad }
    assert_redirected_to quotation_path(assigns(:quotation))
  end

  test "should destroy quotation" do
    assert_difference('Quotation.count', -1) do
      delete :destroy, id: @quotation
    end

    assert_redirected_to quotations_path
  end
end
