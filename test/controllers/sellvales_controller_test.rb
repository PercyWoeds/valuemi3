require 'test_helper'

class SellvalesControllerTest < ActionController::TestCase
  setup do
    @sellvale = sellvales(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sellvales)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sellvale" do
    assert_difference('Sellvale.count') do
      post :create, sellvale: { caja: @sellvale.caja, cantidad: @sellvale.cantidad, chofer: @sellvale.chofer, clear: @sellvale.clear, cod_cli: @sellvale.cod_cli, cod_emp: @sellvale.cod_emp, cod_prod: @sellvale.cod_prod, cod_sucu: @sellvale.cod_sucu, cod_tar: @sellvale.cod_tar, dni_cli: @sellvale.dni_cli, dolat: @sellvale.dolat, fecha: @sellvale.fecha, fpago: @sellvale.fpago, igv: @sellvale.igv, implista: @sellvale.implista, importe: @sellvale.importe, isla: @sellvale.isla, km: @sellvale.km, numero: @sellvale.numero, odometro: @sellvale.odometro, placa: @sellvale.placa, precio: @sellvale.precio, ruc: @sellvale.ruc, serie: @sellvale.serie, td: @sellvale.td, tk_devol: @sellvale.tk_devol, turno: @sellvale.turno }
    end

    assert_redirected_to sellvale_path(assigns(:sellvale))
  end

  test "should show sellvale" do
    get :show, id: @sellvale
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sellvale
    assert_response :success
  end

  test "should update sellvale" do
    patch :update, id: @sellvale, sellvale: { caja: @sellvale.caja, cantidad: @sellvale.cantidad, chofer: @sellvale.chofer, clear: @sellvale.clear, cod_cli: @sellvale.cod_cli, cod_emp: @sellvale.cod_emp, cod_prod: @sellvale.cod_prod, cod_sucu: @sellvale.cod_sucu, cod_tar: @sellvale.cod_tar, dni_cli: @sellvale.dni_cli, dolat: @sellvale.dolat, fecha: @sellvale.fecha, fpago: @sellvale.fpago, igv: @sellvale.igv, implista: @sellvale.implista, importe: @sellvale.importe, isla: @sellvale.isla, km: @sellvale.km, numero: @sellvale.numero, odometro: @sellvale.odometro, placa: @sellvale.placa, precio: @sellvale.precio, ruc: @sellvale.ruc, serie: @sellvale.serie, td: @sellvale.td, tk_devol: @sellvale.tk_devol, turno: @sellvale.turno }
    assert_redirected_to sellvale_path(assigns(:sellvale))
  end

  test "should destroy sellvale" do
    assert_difference('Sellvale.count', -1) do
      delete :destroy, id: @sellvale
    end

    assert_redirected_to sellvales_path
  end
end
