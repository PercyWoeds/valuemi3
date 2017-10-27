require 'test_helper'

class RemisionsControllerTest < ActionController::TestCase
  setup do
    @remision = remisions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:remisions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create remision" do
    assert_difference('Remision.count') do
      post :create, remision: { code: @remision.code, name: @remision.name }
    end

    assert_redirected_to remision_path(assigns(:remision))
  end

  test "should show remision" do
    get :show, id: @remision
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @remision
    assert_response :success
  end

  test "should update remision" do
    patch :update, id: @remision, remision: { code: @remision.code, name: @remision.name }
    assert_redirected_to remision_path(assigns(:remision))
  end

  test "should destroy remision" do
    assert_difference('Remision.count', -1) do
      delete :destroy, id: @remision
    end

    assert_redirected_to remisions_path
  end
end
