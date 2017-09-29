require 'test_helper'

class PayrollDetailsControllerTest < ActionController::TestCase
  setup do
    @payroll_detail = payroll_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payroll_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payroll_detail" do
    assert_difference('PayrollDetail.count') do
      post :create, payroll_detail: { calc10: @payroll_detail.calc10, calc1: @payroll_detail.calc1, calc2: @payroll_detail.calc2, calc3: @payroll_detail.calc3, calc4: @payroll_detail.calc4, calc5: @payroll_detail.calc5, calc6: @payroll_detail.calc6, calc7: @payroll_detail.calc7, calc8: @payroll_detail.calc8, calc9: @payroll_detail.calc9, employee_id: @payroll_detail.employee_id, remneta: @payroll_detail.remneta, remuneracion: @payroll_detail.remuneracion, total1: @payroll_detail.total1, total2: @payroll_detail.total2, total3: @payroll_detail.total3 }
    end

    assert_redirected_to payroll_detail_path(assigns(:payroll_detail))
  end

  test "should show payroll_detail" do
    get :show, id: @payroll_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @payroll_detail
    assert_response :success
  end

  test "should update payroll_detail" do
    patch :update, id: @payroll_detail, payroll_detail: { calc10: @payroll_detail.calc10, calc1: @payroll_detail.calc1, calc2: @payroll_detail.calc2, calc3: @payroll_detail.calc3, calc4: @payroll_detail.calc4, calc5: @payroll_detail.calc5, calc6: @payroll_detail.calc6, calc7: @payroll_detail.calc7, calc8: @payroll_detail.calc8, calc9: @payroll_detail.calc9, employee_id: @payroll_detail.employee_id, remneta: @payroll_detail.remneta, remuneracion: @payroll_detail.remuneracion, total1: @payroll_detail.total1, total2: @payroll_detail.total2, total3: @payroll_detail.total3 }
    assert_redirected_to payroll_detail_path(assigns(:payroll_detail))
  end

  test "should destroy payroll_detail" do
    assert_difference('PayrollDetail.count', -1) do
      delete :destroy, id: @payroll_detail
    end

    assert_redirected_to payroll_details_path
  end
end
