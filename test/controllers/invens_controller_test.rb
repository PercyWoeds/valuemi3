require 'test_helper'

class InvensControllerTest < ActionController::TestCase
  setup do
    @inven = invens(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create inven" do
    assert_difference('Inven.count') do
      post :create, inven: { cod_dep: @inven.cod_dep, cod_emp_a: @inven.cod_emp_a, cod_emp_b: @inven.cod_emp_b, cod_prod: @inven.cod_prod, costo: @inven.costo, dia_a: @inven.dia_a, dia_b: @inven.dia_b, estado_a: @inven.estado_a, estado_b: @inven.estado_b, fecha_a: @inven.fecha_a, fecha_b: @inven.fecha_b, importe: @inven.importe, name2: @inven.name2, order_id_a: @inven.order_id_a, order_id_b: @inven.order_id_b, precio: @inven.precio, stk_act: @inven.stk_act, stk_fisico: @inven.stk_fisico, tm: @inven.tm, turno: @inven.turno }
    end

    assert_redirected_to inven_path(assigns(:inven))
  end

  test "should show inven" do
    get :show, id: @inven
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @inven
    assert_response :success
  end

  test "should update inven" do
    patch :update, id: @inven, inven: { cod_dep: @inven.cod_dep, cod_emp_a: @inven.cod_emp_a, cod_emp_b: @inven.cod_emp_b, cod_prod: @inven.cod_prod, costo: @inven.costo, dia_a: @inven.dia_a, dia_b: @inven.dia_b, estado_a: @inven.estado_a, estado_b: @inven.estado_b, fecha_a: @inven.fecha_a, fecha_b: @inven.fecha_b, importe: @inven.importe, name2: @inven.name2, order_id_a: @inven.order_id_a, order_id_b: @inven.order_id_b, precio: @inven.precio, stk_act: @inven.stk_act, stk_fisico: @inven.stk_fisico, tm: @inven.tm, turno: @inven.turno }
    assert_redirected_to inven_path(assigns(:inven))
  end

  test "should destroy inven" do
    assert_difference('Inven.count', -1) do
      delete :destroy, id: @inven
    end

    assert_redirected_to invens_path
  end
end
