require 'test_helper'

class InventoryDetailsControllerTest < ActionController::TestCase
  setup do
    @inventory_detail = inventory_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:inventory_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create inventory_detail" do
    assert_difference('InventoryDetail.count') do
      post :create, inventory_detail: { cost: @inventory_detail.cost, inventory_id: @inventory_detail.inventory_id, logicalStock: @inventory_detail.logicalStock, physicalStock: @inventory_detail.physicalStock, price: @inventory_detail.price, product_id: @inventory_detail.product_id, totallogical: @inventory_detail.totallogical, totalphysical: @inventory_detail.totalphysical }
    end

    assert_redirected_to inventory_detail_path(assigns(:inventory_detail))
  end

  test "should show inventory_detail" do
    get :show, id: @inventory_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @inventory_detail
    assert_response :success
  end

  test "should update inventory_detail" do
    patch :update, id: @inventory_detail, inventory_detail: { cost: @inventory_detail.cost, inventory_id: @inventory_detail.inventory_id, logicalStock: @inventory_detail.logicalStock, physicalStock: @inventory_detail.physicalStock, price: @inventory_detail.price, product_id: @inventory_detail.product_id, totallogical: @inventory_detail.totallogical, totalphysical: @inventory_detail.totalphysical }
    assert_redirected_to inventory_detail_path(assigns(:inventory_detail))
  end

  test "should destroy inventory_detail" do
    assert_difference('InventoryDetail.count', -1) do
      delete :destroy, id: @inventory_detail
    end

    assert_redirected_to inventory_details_path
  end
end
