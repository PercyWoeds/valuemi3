require 'test_helper'

class OtherIncomesControllerTest < ActionController::TestCase
  setup do
    @other_income = other_incomes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:other_incomes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create other_income" do
    assert_difference('OtherIncome.count') do
      post :create, other_income: { code: @other_income.code, documento: @other_income.documento, employee_id: @other_income.employee_id, importe: @other_income.importe, name: @other_income.name, turno: @other_income.turno }
    end

    assert_redirected_to other_income_path(assigns(:other_income))
  end

  test "should show other_income" do
    get :show, id: @other_income
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @other_income
    assert_response :success
  end

  test "should update other_income" do
    patch :update, id: @other_income, other_income: { code: @other_income.code, documento: @other_income.documento, employee_id: @other_income.employee_id, importe: @other_income.importe, name: @other_income.name, turno: @other_income.turno }
    assert_redirected_to other_income_path(assigns(:other_income))
  end

  test "should destroy other_income" do
    assert_difference('OtherIncome.count', -1) do
      delete :destroy, id: @other_income
    end

    assert_redirected_to other_incomes_path
  end
end
