require 'test_helper'

class InventoriesControllerTest < ActionController::TestCase
  setup do
    @inventory = inventories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:inventories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create inventory" do
    assert_difference('Inventory.count') do
      post :create, inventory: { category_id: @inventory.category_id, comments: @inventory.comments, company_id: @inventory.company_id, cost: @inventory.cost, date_processed: @inventory.date_processed, description: @inventory.description, division: @inventory.division, location_id: @inventory.location_id, logicalStock: @inventory.logicalStock, physicalStock: @inventory.physicalStock, processed: @inventory.processed, total: @inventory.total, user_id: @inventory.user_id }
    end

    assert_redirected_to inventory_path(assigns(:inventory))
  end

  test "should show inventory" do
    get :show, id: @inventory
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @inventory
    assert_response :success
  end

  test "should update inventory" do
    patch :update, id: @inventory, inventory: { category_id: @inventory.category_id, comments: @inventory.comments, company_id: @inventory.company_id, cost: @inventory.cost, date_processed: @inventory.date_processed, description: @inventory.description, division: @inventory.division, location_id: @inventory.location_id, logicalStock: @inventory.logicalStock, physicalStock: @inventory.physicalStock, processed: @inventory.processed, total: @inventory.total, user_id: @inventory.user_id }
    assert_redirected_to inventory_path(assigns(:inventory))
  end

  test "should destroy inventory" do
    assert_difference('Inventory.count', -1) do
      delete :destroy, id: @inventory
    end

    assert_redirected_to inventories_path
  end
end
