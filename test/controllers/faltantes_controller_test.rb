require 'test_helper'

class FaltantesControllerTest < ActionController::TestCase
  setup do
    @faltante = faltantes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:faltantes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create faltante" do
    assert_difference('Faltante.count') do
      post :create, faltante: { comments: @faltante.comments, descrip: @faltante.descrip, employee_id: @faltante.employee_id, tipofaltante_id: @faltante.tipofaltante_id }
    end

    assert_redirected_to faltante_path(assigns(:faltante))
  end

  test "should show faltante" do
    get :show, id: @faltante
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @faltante
    assert_response :success
  end

  test "should update faltante" do
    patch :update, id: @faltante, faltante: { comments: @faltante.comments, descrip: @faltante.descrip, employee_id: @faltante.employee_id, tipofaltante_id: @faltante.tipofaltante_id }
    assert_redirected_to faltante_path(assigns(:faltante))
  end

  test "should destroy faltante" do
    assert_difference('Faltante.count', -1) do
      delete :destroy, id: @faltante
    end

    assert_redirected_to faltantes_path
  end
end
