require 'test_helper'

class PayrollbonisControllerTest < ActionController::TestCase
  setup do
    @payrollboni = payrollbonis(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payrollbonis)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payrollboni" do
    assert_difference('Payrollboni.count') do
      post :create, payrollboni: { code: @payrollboni.code, descrip: @payrollboni.descrip, importe: @payrollboni.importe }
    end

    assert_redirected_to payrollboni_path(assigns(:payrollboni))
  end

  test "should show payrollboni" do
    get :show, id: @payrollboni
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @payrollboni
    assert_response :success
  end

  test "should update payrollboni" do
    patch :update, id: @payrollboni, payrollboni: { code: @payrollboni.code, descrip: @payrollboni.descrip, importe: @payrollboni.importe }
    assert_redirected_to payrollboni_path(assigns(:payrollboni))
  end

  test "should destroy payrollboni" do
    assert_difference('Payrollboni.count', -1) do
      delete :destroy, id: @payrollboni
    end

    assert_redirected_to payrollbonis_path
  end
end
