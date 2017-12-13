require 'test_helper'

class BankdetailsControllerTest < ActionController::TestCase
  setup do
    @bankdetail = bankdetails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bankdetails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bankdetail" do
    assert_difference('Bankdetail.count') do
      post :create, bankdetail: { bank_acount_id: @bankdetail.bank_acount_id, fecha: @bankdetail.fecha, saldo_inicial: @bankdetail.saldo_inicial, total_abono: @bankdetail.total_abono, total_cargo: @bankdetail.total_cargo }
    end

    assert_redirected_to bankdetail_path(assigns(:bankdetail))
  end

  test "should show bankdetail" do
    get :show, id: @bankdetail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bankdetail
    assert_response :success
  end

  test "should update bankdetail" do
    patch :update, id: @bankdetail, bankdetail: { bank_acount_id: @bankdetail.bank_acount_id, fecha: @bankdetail.fecha, saldo_inicial: @bankdetail.saldo_inicial, total_abono: @bankdetail.total_abono, total_cargo: @bankdetail.total_cargo }
    assert_redirected_to bankdetail_path(assigns(:bankdetail))
  end

  test "should destroy bankdetail" do
    assert_difference('Bankdetail.count', -1) do
      delete :destroy, id: @bankdetail
    end

    assert_redirected_to bankdetails_path
  end
end
