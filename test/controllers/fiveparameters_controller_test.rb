require 'test_helper'

class FiveparametersControllerTest < ActionController::TestCase
  setup do
    @fiveparameter = fiveparameters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fiveparameters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fiveparameter" do
    assert_difference('Fiveparameter.count') do
      post :create, fiveparameter: { anio: @fiveparameter.anio, exceso_20: @fiveparameter.exceso_20, exceso_35: @fiveparameter.exceso_35, exceso_45: @fiveparameter.exceso_45, exceso_5: @fiveparameter.exceso_5, hasta_5: @fiveparameter.hasta_5, tasa1: @fiveparameter.tasa1, valor_uit: @fiveparameter.valor_uit, y_hasta_20: @fiveparameter.y_hasta_20, y_hasta_35: @fiveparameter.y_hasta_35, y_hasta_45: @fiveparameter.y_hasta_45 }
    end

    assert_redirected_to fiveparameter_path(assigns(:fiveparameter))
  end

  test "should show fiveparameter" do
    get :show, id: @fiveparameter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fiveparameter
    assert_response :success
  end

  test "should update fiveparameter" do
    patch :update, id: @fiveparameter, fiveparameter: { anio: @fiveparameter.anio, exceso_20: @fiveparameter.exceso_20, exceso_35: @fiveparameter.exceso_35, exceso_45: @fiveparameter.exceso_45, exceso_5: @fiveparameter.exceso_5, hasta_5: @fiveparameter.hasta_5, tasa1: @fiveparameter.tasa1, valor_uit: @fiveparameter.valor_uit, y_hasta_20: @fiveparameter.y_hasta_20, y_hasta_35: @fiveparameter.y_hasta_35, y_hasta_45: @fiveparameter.y_hasta_45 }
    assert_redirected_to fiveparameter_path(assigns(:fiveparameter))
  end

  test "should destroy fiveparameter" do
    assert_difference('Fiveparameter.count', -1) do
      delete :destroy, id: @fiveparameter
    end

    assert_redirected_to fiveparameters_path
  end
end
