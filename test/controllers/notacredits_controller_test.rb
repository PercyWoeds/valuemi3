require 'test_helper'

class NotacreditsControllerTest < ActionController::TestCase
  setup do
    @notacredit = notacredits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notacredits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create notacredit" do
    assert_difference('Notacredit.count') do
      post :create, notacredit: { code: @notacredit.code, customer_id: @notacredit.customer_id, description: @notacredit.description, fecha: @notacredit.fecha, mod_factura: @notacredit.mod_factura, mod_tipo: @notacredit.mod_tipo, moneda_id: @notacredit.moneda_id, motivo: @notacredit.motivo, nota_id: @notacredit.nota_id, processed: @notacredit.processed, subtotal: @notacredit.subtotal, tax: @notacredit.tax, tipo: @notacredit.tipo, total: @notacredit.total }
    end

    assert_redirected_to notacredit_path(assigns(:notacredit))
  end

  test "should show notacredit" do
    get :show, id: @notacredit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @notacredit
    assert_response :success
  end

  test "should update notacredit" do
    patch :update, id: @notacredit, notacredit: { code: @notacredit.code, customer_id: @notacredit.customer_id, description: @notacredit.description, fecha: @notacredit.fecha, mod_factura: @notacredit.mod_factura, mod_tipo: @notacredit.mod_tipo, moneda_id: @notacredit.moneda_id, motivo: @notacredit.motivo, nota_id: @notacredit.nota_id, processed: @notacredit.processed, subtotal: @notacredit.subtotal, tax: @notacredit.tax, tipo: @notacredit.tipo, total: @notacredit.total }
    assert_redirected_to notacredit_path(assigns(:notacredit))
  end

  test "should destroy notacredit" do
    assert_difference('Notacredit.count', -1) do
      delete :destroy, id: @notacredit
    end

    assert_redirected_to notacredits_path
  end
end
