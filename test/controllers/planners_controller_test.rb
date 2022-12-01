require 'test_helper'

class PlannersControllerTest < ActionController::TestCase
  setup do
    @planner = planners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:planners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create planner" do
    assert_difference('Planner.count') do
      post :create, planner: { documento: @planner.documento, employee_id: @planner.employee_id, importe: @planner.importe, observa: @planner.observa, tipomov_id: @planner.tipomov_id }
    end

    assert_redirected_to planner_path(assigns(:planner))
  end

  test "should show planner" do
    get :show, id: @planner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @planner
    assert_response :success
  end

  test "should update planner" do
    patch :update, id: @planner, planner: { documento: @planner.documento, employee_id: @planner.employee_id, importe: @planner.importe, observa: @planner.observa, tipomov_id: @planner.tipomov_id }
    assert_redirected_to planner_path(assigns(:planner))
  end

  test "should destroy planner" do
    assert_difference('Planner.count', -1) do
      delete :destroy, id: @planner
    end

    assert_redirected_to planners_path
  end
end
