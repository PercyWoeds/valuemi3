require 'test_helper'

class TmpContometrosControllerTest < ActionController::TestCase
  setup do
    @tmp_contometro = tmp_contometros(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tmp_contometros)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tmp_contometro" do
    assert_difference('TmpContometro.count') do
      post :create, tmp_contometro: { dcontometroactual_manguera: @tmp_contometro.dcontometroactual_manguera, dcontometroinicial_manguera: @tmp_contometro.dcontometroinicial_manguera, dimporte: @tmp_contometro.dimporte, dnocontabilizado_manguera: @tmp_contometro.dnocontabilizado_manguera, dprecio_producto: @tmp_contometro.dprecio_producto, dstockactual: @tmp_contometro.dstockactual, dtotgalvendido_manguera: @tmp_contometro.dtotgalvendido_manguera, ffechaproceso_cierreturno: @tmp_contometro.ffechaproceso_cierreturno, nid_cierreturno: @tmp_contometro.nid_cierreturno, nid_mangueras: @tmp_contometro.nid_mangueras, nid_producto: @tmp_contometro.nid_producto, nid_surtidor: @tmp_contometro.nid_surtidor, nid_tanque: @tmp_contometro.nid_tanque }
    end

    assert_redirected_to tmp_contometro_path(assigns(:tmp_contometro))
  end

  test "should show tmp_contometro" do
    get :show, id: @tmp_contometro
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tmp_contometro
    assert_response :success
  end

  test "should update tmp_contometro" do
    patch :update, id: @tmp_contometro, tmp_contometro: { dcontometroactual_manguera: @tmp_contometro.dcontometroactual_manguera, dcontometroinicial_manguera: @tmp_contometro.dcontometroinicial_manguera, dimporte: @tmp_contometro.dimporte, dnocontabilizado_manguera: @tmp_contometro.dnocontabilizado_manguera, dprecio_producto: @tmp_contometro.dprecio_producto, dstockactual: @tmp_contometro.dstockactual, dtotgalvendido_manguera: @tmp_contometro.dtotgalvendido_manguera, ffechaproceso_cierreturno: @tmp_contometro.ffechaproceso_cierreturno, nid_cierreturno: @tmp_contometro.nid_cierreturno, nid_mangueras: @tmp_contometro.nid_mangueras, nid_producto: @tmp_contometro.nid_producto, nid_surtidor: @tmp_contometro.nid_surtidor, nid_tanque: @tmp_contometro.nid_tanque }
    assert_redirected_to tmp_contometro_path(assigns(:tmp_contometro))
  end

  test "should destroy tmp_contometro" do
    assert_difference('TmpContometro.count', -1) do
      delete :destroy, id: @tmp_contometro
    end

    assert_redirected_to tmp_contometros_path
  end
end
