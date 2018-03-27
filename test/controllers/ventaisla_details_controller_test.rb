require 'test_helper'

class VentaislaDetailsControllerTest < ActionController::TestCase
  setup do
    @ventaisla_detail = ventaisla_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ventaisla_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ventaisla_detail" do
    assert_difference('VentaislaDetail.count') do
      post :create, ventaisla_detail: { le_ac_gln: @ventaisla_detail.le_ac_gln, le_an_gln: @ventaisla_detail.le_an_gln, price: @ventaisla_detail.price, pump_id: @ventaisla_detail.pump_id, quantity: @ventaisla_detail.quantity, total: @ventaisla_detail.total }
    end

    assert_redirected_to ventaisla_detail_path(assigns(:ventaisla_detail))
  end

  test "should show ventaisla_detail" do
    get :show, id: @ventaisla_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ventaisla_detail
    assert_response :success
  end

  test "should update ventaisla_detail" do
    patch :update, id: @ventaisla_detail, ventaisla_detail: { le_ac_gln: @ventaisla_detail.le_ac_gln, le_an_gln: @ventaisla_detail.le_an_gln, price: @ventaisla_detail.price, pump_id: @ventaisla_detail.pump_id, quantity: @ventaisla_detail.quantity, total: @ventaisla_detail.total }
    assert_redirected_to ventaisla_detail_path(assigns(:ventaisla_detail))
  end

  test "should destroy ventaisla_detail" do
    assert_difference('VentaislaDetail.count', -1) do
      delete :destroy, id: @ventaisla_detail
    end

    assert_redirected_to ventaisla_details_path
  end
end
