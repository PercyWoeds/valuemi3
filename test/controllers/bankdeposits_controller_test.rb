require 'test_helper'

class BankdepositsControllerTest < ActionController::TestCase
  setup do
    @bankdeposit = bankdeposits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bankdeposits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bankdeposit" do
    assert_difference('Bankdeposit.count') do
      post :create, bankdeposit: { bank_account_id: @bankdeposit.bank_account_id, code: @bankdeposit.code, document_id: @bankdeposit.document_id, documento: @bankdeposit.documento, fecha: @bankdeposit.fecha, total: @bankdeposit.total }
    end

    assert_redirected_to bankdeposit_path(assigns(:bankdeposit))
  end

  test "should show bankdeposit" do
    get :show, id: @bankdeposit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bankdeposit
    assert_response :success
  end

  test "should update bankdeposit" do
    patch :update, id: @bankdeposit, bankdeposit: { bank_account_id: @bankdeposit.bank_account_id, code: @bankdeposit.code, document_id: @bankdeposit.document_id, documento: @bankdeposit.documento, fecha: @bankdeposit.fecha, total: @bankdeposit.total }
    assert_redirected_to bankdeposit_path(assigns(:bankdeposit))
  end

  test "should destroy bankdeposit" do
    assert_difference('Bankdeposit.count', -1) do
      delete :destroy, id: @bankdeposit
    end

    assert_redirected_to bankdeposits_path
  end
end
