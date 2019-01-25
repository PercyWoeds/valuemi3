require 'test_helper'

class TipomovsControllerTest < ActionController::TestCase
  setup do
    @tipomov = tipomovs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipomovs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipomov" do
    assert_difference('Tipomov.count') do
      post :create, tipomov: { code: @tipomov.code, descrip: @tipomov.descrip }
    end

    assert_redirected_to tipomov_path(assigns(:tipomov))
  end

  test "should show tipomov" do
    get :show, id: @tipomov
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipomov
    assert_response :success
  end

  test "should update tipomov" do
    patch :update, id: @tipomov, tipomov: { code: @tipomov.code, descrip: @tipomov.descrip }
    assert_redirected_to tipomov_path(assigns(:tipomov))
  end

  test "should destroy tipomov" do
    assert_difference('Tipomov.count', -1) do
      delete :destroy, id: @tipomov
    end

    assert_redirected_to tipomovs_path
  end
end
