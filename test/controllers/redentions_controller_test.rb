require 'test_helper'

class RedentionsControllerTest < ActionController::TestCase
  setup do
    @redention = redentions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:redentions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create redention" do
    assert_difference('Redention.count') do
      post :create, redention: { balance: @redention.balance, charge: @redention.charge, code: @redention.code, comments: @redention.comments, company_id: @redention.company_id, customer_id: @redention.customer_id, customer_id: @redention.customer_id, date_processed: @redention.date_processed, description: @redention.description, descuento: @redention.descuento, detraccion: @redention.detraccion, division_id: @redention.division_id, document_id: @redention.document_id, factura_id: @redention.factura_id, fecha2: @redention.fecha2, fecha: @redention.fecha, location_id: @redention.location_id, moneda_id: @redention.moneda_id, numero2: @redention.numero2, numero: @redention.numero, observ: @redention.observ, pago: @redention.pago, payment_id: @redention.payment_id, processed: @redention.processed, return: @redention.return, ruc: @redention.ruc, serie: @redention.serie, subtotal: @redention.subtotal, tarjeta_id: @redention.tarjeta_id, tax: @redention.tax, tipo: @redention.tipo, tipoventa: @redention.tipoventa, tipoventa_id: @redention.tipoventa_id, total: @redention.total, user_id: @redention.user_id, year_mounth: @redention.year_mounth }
    end

    assert_redirected_to redention_path(assigns(:redention))
  end

  test "should show redention" do
    get :show, id: @redention
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @redention
    assert_response :success
  end

  test "should update redention" do
    patch :update, id: @redention, redention: { balance: @redention.balance, charge: @redention.charge, code: @redention.code, comments: @redention.comments, company_id: @redention.company_id, customer_id: @redention.customer_id, customer_id: @redention.customer_id, date_processed: @redention.date_processed, description: @redention.description, descuento: @redention.descuento, detraccion: @redention.detraccion, division_id: @redention.division_id, document_id: @redention.document_id, factura_id: @redention.factura_id, fecha2: @redention.fecha2, fecha: @redention.fecha, location_id: @redention.location_id, moneda_id: @redention.moneda_id, numero2: @redention.numero2, numero: @redention.numero, observ: @redention.observ, pago: @redention.pago, payment_id: @redention.payment_id, processed: @redention.processed, return: @redention.return, ruc: @redention.ruc, serie: @redention.serie, subtotal: @redention.subtotal, tarjeta_id: @redention.tarjeta_id, tax: @redention.tax, tipo: @redention.tipo, tipoventa: @redention.tipoventa, tipoventa_id: @redention.tipoventa_id, total: @redention.total, user_id: @redention.user_id, year_mounth: @redention.year_mounth }
    assert_redirected_to redention_path(assigns(:redention))
  end

  test "should destroy redention" do
    assert_difference('Redention.count', -1) do
      delete :destroy, id: @redention
    end

    assert_redirected_to redentions_path
  end
end
