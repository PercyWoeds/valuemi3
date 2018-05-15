require 'test_helper'

class VentaProductosControllerTest < ActionController::TestCase
  setup do
    @venta_producto = venta_productos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:venta_productos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create venta_producto" do
    assert_difference('VentaProducto.count') do
      post :create, venta_producto: { division_id: @venta_producto.division_id, document_id: @venta_producto.document_id, documento: @venta_producto.documento, fecha: @venta_producto.fecha, tarjeta_id: @venta_producto.tarjeta_id, total_efe: @venta_producto.total_efe, total_tar: @venta_producto.total_tar }
    end

    assert_redirected_to venta_producto_path(assigns(:venta_producto))
  end

  test "should show venta_producto" do
    get :show, id: @venta_producto
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @venta_producto
    assert_response :success
  end

  test "should update venta_producto" do
    patch :update, id: @venta_producto, venta_producto: { division_id: @venta_producto.division_id, document_id: @venta_producto.document_id, documento: @venta_producto.documento, fecha: @venta_producto.fecha, tarjeta_id: @venta_producto.tarjeta_id, total_efe: @venta_producto.total_efe, total_tar: @venta_producto.total_tar }
    assert_redirected_to venta_producto_path(assigns(:venta_producto))
  end

  test "should destroy venta_producto" do
    assert_difference('VentaProducto.count', -1) do
      delete :destroy, id: @venta_producto
    end

    assert_redirected_to venta_productos_path
  end
end
