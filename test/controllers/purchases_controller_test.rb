require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
  setup do
    @purchase = purchases(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:purchases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create purchase" do
    assert_difference('Purchase.count') do
      post :create, purchase: { balance: @purchase.balance, charge: @purchase.charge, comments: @purchase.comments, company_id: @purchase.company_id, date1: @purchase.date1, date2: @purchase.date2, discount: @purchase.discount, division: @purchase.division, document: @purchase.document, document_type_id: @purchase.document_type_id, exchange: @purchase.exchange, integer: @purchase.integer, location_id: @purchase.location_id, money_type: @purchase.money_type, order1: @purchase.order1, other: @purchase.other, payable_amount: @purchase.payable_amount, payment: @purchase.payment, plate_id: @purchase.plate_id, price_public: @purchase.price_public, price_with_tax: @purchase.price_with_tax, price_without_tax: @purchase.price_without_tax, pricestatus: @purchase.pricestatus, product_id: @purchase.product_id, quantity: @purchase.quantity, status: @purchase.status, supplier_id: @purchase.supplier_id, tank_id: @purchase.tank_id, tax1: @purchase.tax1, tax2: @purchase.tax2, tax_amount: @purchase.tax_amount, total_amount: @purchase.total_amount, unit_id: @purchase.unit_id, user_id: @purchase.user_id }
    end

    assert_redirected_to purchase_path(assigns(:purchase))
  end

  test "should show purchase" do
    get :show, id: @purchase
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @purchase
    assert_response :success
  end

  test "should update purchase" do
    patch :update, id: @purchase, purchase: { balance: @purchase.balance, charge: @purchase.charge, comments: @purchase.comments, company_id: @purchase.company_id, date1: @purchase.date1, date2: @purchase.date2, discount: @purchase.discount, division: @purchase.division, document: @purchase.document, document_type_id: @purchase.document_type_id, exchange: @purchase.exchange, integer: @purchase.integer, location_id: @purchase.location_id, money_type: @purchase.money_type, order1: @purchase.order1, other: @purchase.other, payable_amount: @purchase.payable_amount, payment: @purchase.payment, plate_id: @purchase.plate_id, price_public: @purchase.price_public, price_with_tax: @purchase.price_with_tax, price_without_tax: @purchase.price_without_tax, pricestatus: @purchase.pricestatus, product_id: @purchase.product_id, quantity: @purchase.quantity, status: @purchase.status, supplier_id: @purchase.supplier_id, tank_id: @purchase.tank_id, tax1: @purchase.tax1, tax2: @purchase.tax2, tax_amount: @purchase.tax_amount, total_amount: @purchase.total_amount, unit_id: @purchase.unit_id, user_id: @purchase.user_id }
    assert_redirected_to purchase_path(assigns(:purchase))
  end

  test "should destroy purchase" do
    assert_difference('Purchase.count', -1) do
      delete :destroy, id: @purchase
    end

    assert_redirected_to purchases_path
  end
end
