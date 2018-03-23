require 'test_helper'

class VentaControllerTest < ActionController::TestCase
  setup do
    @ventum = venta(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:venta)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ventum" do
    assert_difference('Ventum.count') do
      post :create, ventum: { caja: @ventum.caja, cantidad: @ventum.cantidad, chofer: @ventum.chofer, cod_cli: @ventum.cod_cli, cod_emp: @ventum.cod_emp, cod_prod: @ventum.cod_prod, cod_sucu: @ventum.cod_sucu, cod_tar: @ventum.cod_tar, dni_cli: @ventum.dni_cli, dolat: @ventum.dolat, fecha: @ventum.fecha, fpago: @ventum.fpago, igv: @ventum.igv, implista: @ventum.implista, importe: @ventum.importe, isla: @ventum.isla, km: @ventum.km, numero: @ventum.numero, odometro: @ventum.odometro, placa: @ventum.placa, precio: @ventum.precio, ruc: @ventum.ruc, serie: @ventum.serie, td: @ventum.td, tk_devol: @ventum.tk_devol, turno: @ventum.turno }
    end

    assert_redirected_to ventum_path(assigns(:ventum))
  end

  test "should show ventum" do
    get :show, id: @ventum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ventum
    assert_response :success
  end

  test "should update ventum" do
    patch :update, id: @ventum, ventum: { caja: @ventum.caja, cantidad: @ventum.cantidad, chofer: @ventum.chofer, cod_cli: @ventum.cod_cli, cod_emp: @ventum.cod_emp, cod_prod: @ventum.cod_prod, cod_sucu: @ventum.cod_sucu, cod_tar: @ventum.cod_tar, dni_cli: @ventum.dni_cli, dolat: @ventum.dolat, fecha: @ventum.fecha, fpago: @ventum.fpago, igv: @ventum.igv, implista: @ventum.implista, importe: @ventum.importe, isla: @ventum.isla, km: @ventum.km, numero: @ventum.numero, odometro: @ventum.odometro, placa: @ventum.placa, precio: @ventum.precio, ruc: @ventum.ruc, serie: @ventum.serie, td: @ventum.td, tk_devol: @ventum.tk_devol, turno: @ventum.turno }
    assert_redirected_to ventum_path(assigns(:ventum))
  end

  test "should destroy ventum" do
    assert_difference('Ventum.count', -1) do
      delete :destroy, id: @ventum
    end

    assert_redirected_to venta_path
  end
end
