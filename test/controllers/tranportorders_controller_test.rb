require 'test_helper'

class TranportordersControllerTest < ActionController::TestCase
  setup do
    @tranportorder = tranportorders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tranportorders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tranportorder" do
    assert_difference('Tranportorder.count') do
      post :create, tranportorder: { code: @tranportorder.code, comments: @tranportorder.comments, company_id: @tranportorder.company_id, description: @tranportorder.description, division_id: @tranportorder.division_id, employee2_id: @tranportorder.employee2_id, employee_id: @tranportorder.employee_id, fecha1: @tranportorder.fecha1, fecha2: @tranportorder.fecha2, location_id: @tranportorder.location_id, processed: @tranportorder.processed, truck2_id: @tranportorder.truck2_id, truck_id: @tranportorder.truck_id, ubication2_id: @tranportorder.ubication2_id, ubication_id: @tranportorder.ubication_id }
    end

    assert_redirected_to tranportorder_path(assigns(:tranportorder))
  end

  test "should show tranportorder" do
    get :show, id: @tranportorder
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tranportorder
    assert_response :success
  end

  test "should update tranportorder" do
    patch :update, id: @tranportorder, tranportorder: { code: @tranportorder.code, comments: @tranportorder.comments, company_id: @tranportorder.company_id, description: @tranportorder.description, division_id: @tranportorder.division_id, employee2_id: @tranportorder.employee2_id, employee_id: @tranportorder.employee_id, fecha1: @tranportorder.fecha1, fecha2: @tranportorder.fecha2, location_id: @tranportorder.location_id, processed: @tranportorder.processed, truck2_id: @tranportorder.truck2_id, truck_id: @tranportorder.truck_id, ubication2_id: @tranportorder.ubication2_id, ubication_id: @tranportorder.ubication_id }
    assert_redirected_to tranportorder_path(assigns(:tranportorder))
  end

  test "should destroy tranportorder" do
    assert_difference('Tranportorder.count', -1) do
      delete :destroy, id: @tranportorder
    end

    assert_redirected_to tranportorders_path
  end
end
