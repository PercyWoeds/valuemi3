require 'test_helper'

class DepositosControllerTest < ActionController::TestCase
  setup do
    @deposito = depositos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:depositos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create deposito" do
    assert_difference('Deposito.count') do
      post :create, deposito: { bank_account_id: @deposito.bank_account_id, bank_acount_id: @deposito.bank_acount_id, code: @deposito.code, comments: @deposito.comments, company_id: @deposito.company_id, compen: @deposito.compen, concept_id: @deposito.concept_id, customer_id: @deposito.customer_id, date_processed: @deposito.date_processed, descrip: @deposito.descrip, division_id: @deposito.division_id, document_id: @deposito.document_id, documento: @deposito.documento, fecha1: @deposito.fecha1, fecha2: @deposito.fecha2, location_id: @deposito.location_id, nrooperacion: @deposito.nrooperacion, processed: @deposito.processed, tm: @deposito.tm, total: @deposito.total, user_id: @deposito.user_id }
    end

    assert_redirected_to deposito_path(assigns(:deposito))
  end

  test "should show deposito" do
    get :show, id: @deposito
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @deposito
    assert_response :success
  end

  test "should update deposito" do
    patch :update, id: @deposito, deposito: { bank_account_id: @deposito.bank_account_id, bank_acount_id: @deposito.bank_acount_id, code: @deposito.code, comments: @deposito.comments, company_id: @deposito.company_id, compen: @deposito.compen, concept_id: @deposito.concept_id, customer_id: @deposito.customer_id, date_processed: @deposito.date_processed, descrip: @deposito.descrip, division_id: @deposito.division_id, document_id: @deposito.document_id, documento: @deposito.documento, fecha1: @deposito.fecha1, fecha2: @deposito.fecha2, location_id: @deposito.location_id, nrooperacion: @deposito.nrooperacion, processed: @deposito.processed, tm: @deposito.tm, total: @deposito.total, user_id: @deposito.user_id }
    assert_redirected_to deposito_path(assigns(:deposito))
  end

  test "should destroy deposito" do
    assert_difference('Deposito.count', -1) do
      delete :destroy, id: @deposito
    end

    assert_redirected_to depositos_path
  end
end
