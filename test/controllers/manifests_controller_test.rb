require 'test_helper'

class ManifestsControllerTest < ActionController::TestCase
  setup do
    @manifest = manifests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manifests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manifest" do
    assert_difference('Manifest.count') do
      post :create, manifest: { alto: @manifest.alto, ancho: @manifest.ancho, bultos: @manifest.bultos, camapeso: @manifest.camapeso, camaqty: @manifest.camaqty, camionetapeso: @manifest.camionetapeso, camionetaqty: @manifest.camionetaqty, camionpeso: @manifest.camionpeso, camionqty: @manifest.camionqty, company_id: @manifest.company_id, contacto1: @manifest.contacto1, contacto2: @manifest.contacto2, customer_id: @manifest.customer_id, especificacion: @manifest.especificacion, extenpeso: @manifest.extenpeso, extenqty: @manifest.extenqty, fecha1: @manifest.fecha1, fecha2: @manifest.fecha2, largo: @manifest.largo, modularpeso: @manifest.modularpeso, modularqty: @manifest.modularqty, observa2: @manifest.observa2, observa: @manifest.observa, otros: @manifest.otros, peso: @manifest.peso, punto2_id: @manifest.punto2_id, punto_id: @manifest.punto_id, semipeso: @manifest.semipeso, semiqty: @manifest.semiqty, solicitante: @manifest.solicitante, telefono1: @manifest.telefono1, telefono1: @manifest.telefono1, telefono2: @manifest.telefono2 }
    end

    assert_redirected_to manifest_path(assigns(:manifest))
  end

  test "should show manifest" do
    get :show, id: @manifest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manifest
    assert_response :success
  end

  test "should update manifest" do
    patch :update, id: @manifest, manifest: { alto: @manifest.alto, ancho: @manifest.ancho, bultos: @manifest.bultos, camapeso: @manifest.camapeso, camaqty: @manifest.camaqty, camionetapeso: @manifest.camionetapeso, camionetaqty: @manifest.camionetaqty, camionpeso: @manifest.camionpeso, camionqty: @manifest.camionqty, company_id: @manifest.company_id, contacto1: @manifest.contacto1, contacto2: @manifest.contacto2, customer_id: @manifest.customer_id, especificacion: @manifest.especificacion, extenpeso: @manifest.extenpeso, extenqty: @manifest.extenqty, fecha1: @manifest.fecha1, fecha2: @manifest.fecha2, largo: @manifest.largo, modularpeso: @manifest.modularpeso, modularqty: @manifest.modularqty, observa2: @manifest.observa2, observa: @manifest.observa, otros: @manifest.otros, peso: @manifest.peso, punto2_id: @manifest.punto2_id, punto_id: @manifest.punto_id, semipeso: @manifest.semipeso, semiqty: @manifest.semiqty, solicitante: @manifest.solicitante, telefono1: @manifest.telefono1, telefono1: @manifest.telefono1, telefono2: @manifest.telefono2 }
    assert_redirected_to manifest_path(assigns(:manifest))
  end

  test "should destroy manifest" do
    assert_difference('Manifest.count', -1) do
      delete :destroy, id: @manifest
    end

    assert_redirected_to manifests_path
  end
end
