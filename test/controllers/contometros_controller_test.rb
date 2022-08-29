require 'test_helper'

class ContometrosControllerTest < ActionController::TestCase
  setup do
    @contometro = contometros(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contometros)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contometro" do
    assert_difference('Contometro.count') do
      post :create, contometro: { dcontometroactual_manguera: @contometro.dcontometroactual_manguera, dcontometroinicial_manguera: @contometro.dcontometroinicial_manguera, dimporte: @contometro.dimporte, dnocontabilizado_manguera: @contometro.dnocontabilizado_manguera, dprecio_producto: @contometro.dprecio_producto, dstockactual: @contometro.dstockactual, dtotgalvendido_manguera: @contometro.dtotgalvendido_manguera, ffechaproceso_cierreturno: @contometro.ffechaproceso_cierreturno, nid_cierreturno: @contometro.nid_cierreturno, nid_mangueras: @contometro.nid_mangueras, nid_producto: @contometro.nid_producto, nid_surtidor: @contometro.nid_surtidor, nid_tanque: @contometro.nid_tanque }
    end

    assert_redirected_to contometro_path(assigns(:contometro))
  end

  test "should show contometro" do
    get :show, id: @contometro
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contometro
    assert_response :success
  end

  test "should update contometro" do
    patch :update, id: @contometro, contometro: { dcontometroactual_manguera: @contometro.dcontometroactual_manguera, dcontometroinicial_manguera: @contometro.dcontometroinicial_manguera, dimporte: @contometro.dimporte, dnocontabilizado_manguera: @contometro.dnocontabilizado_manguera, dprecio_producto: @contometro.dprecio_producto, dstockactual: @contometro.dstockactual, dtotgalvendido_manguera: @contometro.dtotgalvendido_manguera, ffechaproceso_cierreturno: @contometro.ffechaproceso_cierreturno, nid_cierreturno: @contometro.nid_cierreturno, nid_mangueras: @contometro.nid_mangueras, nid_producto: @contometro.nid_producto, nid_surtidor: @contometro.nid_surtidor, nid_tanque: @contometro.nid_tanque }
    assert_redirected_to contometro_path(assigns(:contometro))
  end

  test "should destroy contometro" do
    assert_difference('Contometro.count', -1) do
      delete :destroy, id: @contometro
    end

    assert_redirected_to contometros_path
  end
end
