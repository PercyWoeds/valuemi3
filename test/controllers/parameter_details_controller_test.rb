require 'test_helper'

class ParameterDetailsControllerTest < ActionController::TestCase
  setup do
    @parameter_detail = parameter_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:parameter_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create parameter_detail" do
    assert_difference('ParameterDetail.count') do
      post :create, parameter_detail: { afp_id: @parameter_detail.afp_id, aporte: @parameter_detail.aporte, comision: @parameter_detail.comision, parameter_id: @parameter_detail.parameter_id, seguro: @parameter_detail.seguro }
    end

    assert_redirected_to parameter_detail_path(assigns(:parameter_detail))
  end

  test "should show parameter_detail" do
    get :show, id: @parameter_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @parameter_detail
    assert_response :success
  end

  test "should update parameter_detail" do
    patch :update, id: @parameter_detail, parameter_detail: { afp_id: @parameter_detail.afp_id, aporte: @parameter_detail.aporte, comision: @parameter_detail.comision, parameter_id: @parameter_detail.parameter_id, seguro: @parameter_detail.seguro }
    assert_redirected_to parameter_detail_path(assigns(:parameter_detail))
  end

  test "should destroy parameter_detail" do
    assert_difference('ParameterDetail.count', -1) do
      delete :destroy, id: @parameter_detail
    end

    assert_redirected_to parameter_details_path
  end
end
