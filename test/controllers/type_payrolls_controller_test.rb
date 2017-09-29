require 'test_helper'

class TypePayrollsControllerTest < ActionController::TestCase
  setup do
    @type_payroll = type_payrolls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:type_payrolls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create type_payroll" do
    assert_difference('TypePayroll.count') do
      post :create, type_payroll: { code: @type_payroll.code, descrip: @type_payroll.descrip }
    end

    assert_redirected_to type_payroll_path(assigns(:type_payroll))
  end

  test "should show type_payroll" do
    get :show, id: @type_payroll
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @type_payroll
    assert_response :success
  end

  test "should update type_payroll" do
    patch :update, id: @type_payroll, type_payroll: { code: @type_payroll.code, descrip: @type_payroll.descrip }
    assert_redirected_to type_payroll_path(assigns(:type_payroll))
  end

  test "should destroy type_payroll" do
    assert_difference('TypePayroll.count', -1) do
      delete :destroy, id: @type_payroll
    end

    assert_redirected_to type_payrolls_path
  end
end
