require 'test_helper'

class TmsControllerTest < ActionController::TestCase
  setup do
    @tm = tms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tm" do
    assert_difference('Tm.count') do
      post :create, tm: { code: @tm.code, descrip: @tm.descrip }
    end

    assert_redirected_to tm_path(assigns(:tm))
  end

  test "should show tm" do
    get :show, id: @tm
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tm
    assert_response :success
  end

  test "should update tm" do
    patch :update, id: @tm, tm: { code: @tm.code, descrip: @tm.descrip }
    assert_redirected_to tm_path(assigns(:tm))
  end

  test "should destroy tm" do
    assert_difference('Tm.count', -1) do
      delete :destroy, id: @tm
    end

    assert_redirected_to tms_path
  end
end
