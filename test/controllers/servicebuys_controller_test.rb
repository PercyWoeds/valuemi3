require 'test_helper'

class ServicebuysControllerTest < ActionController::TestCase
  setup do
    @servicebuy = servicebuys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:servicebuys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create servicebuy" do
    assert_difference('Servicebuy.count') do
      post :create, servicebuy: { code: @servicebuy.code, comments: @servicebuy.comments, company_id: @servicebuy.company_id, cost: @servicebuy.cost, currtotal: @servicebuy.currtotal, description: @servicebuy.description, discount: @servicebuy.discount, i: @servicebuy.i, name: @servicebuy.name, price: @servicebuy.price, quantity: @servicebuy.quantity, tax1: @servicebuy.tax1, tax1_name: @servicebuy.tax1_name, tax2: @servicebuy.tax2, tax2_name: @servicebuy.tax2_name, tax3: @servicebuy.tax3, tax3_name: @servicebuy.tax3_name, total: @servicebuy.total }
    end

    assert_redirected_to servicebuy_path(assigns(:servicebuy))
  end

  test "should show servicebuy" do
    get :show, id: @servicebuy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @servicebuy
    assert_response :success
  end

  test "should update servicebuy" do
    patch :update, id: @servicebuy, servicebuy: { code: @servicebuy.code, comments: @servicebuy.comments, company_id: @servicebuy.company_id, cost: @servicebuy.cost, currtotal: @servicebuy.currtotal, description: @servicebuy.description, discount: @servicebuy.discount, i: @servicebuy.i, name: @servicebuy.name, price: @servicebuy.price, quantity: @servicebuy.quantity, tax1: @servicebuy.tax1, tax1_name: @servicebuy.tax1_name, tax2: @servicebuy.tax2, tax2_name: @servicebuy.tax2_name, tax3: @servicebuy.tax3, tax3_name: @servicebuy.tax3_name, total: @servicebuy.total }
    assert_redirected_to servicebuy_path(assigns(:servicebuy))
  end

  test "should destroy servicebuy" do
    assert_difference('Servicebuy.count', -1) do
      delete :destroy, id: @servicebuy
    end

    assert_redirected_to servicebuys_path
  end
end
