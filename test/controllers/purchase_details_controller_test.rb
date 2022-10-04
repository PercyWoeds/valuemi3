require 'test_helper'

class PurchaseDetailsControllerTest < ActionController::TestCase
  test "should get product_id:integer" do
    get :product_id:integer
    assert_response :success
  end

  test "should get unit_id:integer" do
    get :unit_id:integer
    assert_response :success
  end

  test "should get price_with_tax:float" do
    get :price_with_tax:float
    assert_response :success
  end

  test "should get price_without_tax:float" do
    get :price_without_tax:float
    assert_response :success
  end

  test "should get price_public:float" do
    get :price_public:float
    assert_response :success
  end

  test "should get quantity:float" do
    get :quantity:float
    assert_response :success
  end

  test "should get totaltax:float" do
    get :totaltax:float
    assert_response :success
  end

  test "should get totaltax2:float" do
    get :totaltax2:float
    assert_response :success
  end

  test "should get discount:float" do
    get :discount:float
    assert_response :success
  end

  test "should get total:float" do
    get :total:float
    assert_response :success
  end

  test "should get purchase_id:integer" do
    get :purchase_id:integer
    assert_response :success
  end

  test "should get grifo:float" do
    get :grifo:float
    assert_response :success
  end

  test "should get mayorista:float" do
    get :mayorista:float
    assert_response :success
  end

  test "should get fecha1:datetime" do
    get :fecha1:datetime
    assert_response :success
  end

  test "should get qty1:float" do
    get :qty1:float
    assert_response :success
  end

  test "should get fecha2:datetime" do
    get :fecha2:datetime
    assert_response :success
  end

  test "should get qty2:float" do
    get :qty2:float
    assert_response :success
  end

  test "should get fecha3:datetime" do
    get :fecha3:datetime
    assert_response :success
  end

  test "should get qty3:float" do
    get :qty3:float
    assert_response :success
  end

end
