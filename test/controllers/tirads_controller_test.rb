require 'test_helper'

class TiradsControllerTest < ActionController::TestCase
  setup do
    @tirad = tirads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tirads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tirad" do
    assert_difference('Tirad.count') do
      post :create, tirad: { employee_id: @tirad.employee_id, fecha: @tirad.fecha, importe: @tirad.importe, turno: @tirad.turno }
    end

    assert_redirected_to tirad_path(assigns(:tirad))
  end

  test "should show tirad" do
    get :show, id: @tirad
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tirad
    assert_response :success
  end

  test "should update tirad" do
    patch :update, id: @tirad, tirad: { employee_id: @tirad.employee_id, fecha: @tirad.fecha, importe: @tirad.importe, turno: @tirad.turno }
    assert_redirected_to tirad_path(assigns(:tirad))
  end

  test "should destroy tirad" do
    assert_difference('Tirad.count', -1) do
      delete :destroy, id: @tirad
    end

    assert_redirected_to tirads_path
  end
end
