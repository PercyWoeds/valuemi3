require 'test_helper'

class RedentionDetailsControllerTest < ActionController::TestCase
  setup do
    @redention_detail = redention_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:redention_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create redention_detail" do
    assert_difference('RedentionDetail.count') do
      post :create, redention_detail: { discount: @redention_detail.discount, factura_id: @redention_detail.factura_id, price: @redention_detail.price, product_id: @redention_detail.product_id, quantity: @redention_detail.quantity, total: @redention_detail.total }
    end

    assert_redirected_to redention_detail_path(assigns(:redention_detail))
  end

  test "should show redention_detail" do
    get :show, id: @redention_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @redention_detail
    assert_response :success
  end

  test "should update redention_detail" do
    patch :update, id: @redention_detail, redention_detail: { discount: @redention_detail.discount, factura_id: @redention_detail.factura_id, price: @redention_detail.price, product_id: @redention_detail.product_id, quantity: @redention_detail.quantity, total: @redention_detail.total }
    assert_redirected_to redention_detail_path(assigns(:redention_detail))
  end

  test "should destroy redention_detail" do
    assert_difference('RedentionDetail.count', -1) do
      delete :destroy, id: @redention_detail
    end

    assert_redirected_to redention_details_path
  end
end
