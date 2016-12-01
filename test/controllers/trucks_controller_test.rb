require 'test_helper'

class TrucksControllerTest < ActionController::TestCase
  setup do
    @truck = trucks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trucks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create truck" do
    assert_difference('Truck.count') do
      post :create, truck: { anio: @truck.anio, carroceria: @truck.carroceria, certificado: @truck.certificado, clase: @truck.clase, code: @truck.code, config: @truck.config, ejes: @truck.ejes, estado: @truck.estado, licencia: @truck.licencia, marca_id: @truck.marca_id, modelo_id: @truck.modelo_id, neumatico: @truck.neumatico, placa: @truck.placa, propio: @truck.propio }
    end

    assert_redirected_to truck_path(assigns(:truck))
  end

  test "should show truck" do
    get :show, id: @truck
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @truck
    assert_response :success
  end

  test "should update truck" do
    patch :update, id: @truck, truck: { anio: @truck.anio, carroceria: @truck.carroceria, certificado: @truck.certificado, clase: @truck.clase, code: @truck.code, config: @truck.config, ejes: @truck.ejes, estado: @truck.estado, licencia: @truck.licencia, marca_id: @truck.marca_id, modelo_id: @truck.modelo_id, neumatico: @truck.neumatico, placa: @truck.placa, propio: @truck.propio }
    assert_redirected_to truck_path(assigns(:truck))
  end

  test "should destroy truck" do
    assert_difference('Truck.count', -1) do
      delete :destroy, id: @truck
    end

    assert_redirected_to trucks_path
  end
end
