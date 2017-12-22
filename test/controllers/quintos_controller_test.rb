require 'test_helper'

class QuintosControllerTest < ActionController::TestCase
  setup do
    @quinto = quintos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quintos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quinto" do
    assert_difference('Quinto.count') do
      post :create, quinto: { abr1: @quinto.abr1, abr2: @quinto.abr2, ago1: @quinto.ago1, ago2: @quinto.ago2, anio: @quinto.anio, asignacion: @quinto.asignacion, bonextra: @quinto.bonextra, deduccion7: @quinto.deduccion7, dic2: @quinto.dic2, employee_id: @quinto.employee_id, ene1: @quinto.ene1, ene2: @quinto.ene2, feb1: @quinto.feb1, feb2: @quinto.feb2, gratidic: @quinto.gratidic, gratijulio: @quinto.gratijulio, hextras: @quinto.hextras, jul1: @quinto.jul1, jul2: @quinto.jul2, jun1: @quinto.jun1, jun2: @quinto.jun2, mar1: @quinto.mar1, mar2: @quinto.mar2, may1: @quinto.may1, may2: @quinto.may2, mes: @quinto.mes, mes_pendiente: @quinto.mes_pendiente, mes_proy: @quinto.mes_proy, nov1: @quinto.nov1, nov2: @quinto.nov2, oct1: @quinto.oct1, oct2: @quinto.oct2, otros1: @quinto.otros1, otros2: @quinto.otros2, rem_actual: @quinto.rem_actual, rem_mes: @quinto.rem_mes, rem_proyectada: @quinto.rem_proyectada, renta_bruta: @quinto.renta_bruta, renta_impo1: @quinto.renta_impo1, renta_impo2: @quinto.renta_impo2, renta_impo3: @quinto.renta_impo3, renta_impo4: @quinto.renta_impo4, renta_impo5: @quinto.renta_impo5, renta_impo_ret: @quinto.renta_impo_ret, retencion_mensual: @quinto.retencion_mensual, set1: @quinto.set1, set2: @quinto.set2, total_renta: @quinto.total_renta, total_renta_impo: @quinto.total_renta_impo }
    end

    assert_redirected_to quinto_path(assigns(:quinto))
  end

  test "should show quinto" do
    get :show, id: @quinto
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quinto
    assert_response :success
  end

  test "should update quinto" do
    patch :update, id: @quinto, quinto: { abr1: @quinto.abr1, abr2: @quinto.abr2, ago1: @quinto.ago1, ago2: @quinto.ago2, anio: @quinto.anio, asignacion: @quinto.asignacion, bonextra: @quinto.bonextra, deduccion7: @quinto.deduccion7, dic2: @quinto.dic2, employee_id: @quinto.employee_id, ene1: @quinto.ene1, ene2: @quinto.ene2, feb1: @quinto.feb1, feb2: @quinto.feb2, gratidic: @quinto.gratidic, gratijulio: @quinto.gratijulio, hextras: @quinto.hextras, jul1: @quinto.jul1, jul2: @quinto.jul2, jun1: @quinto.jun1, jun2: @quinto.jun2, mar1: @quinto.mar1, mar2: @quinto.mar2, may1: @quinto.may1, may2: @quinto.may2, mes: @quinto.mes, mes_pendiente: @quinto.mes_pendiente, mes_proy: @quinto.mes_proy, nov1: @quinto.nov1, nov2: @quinto.nov2, oct1: @quinto.oct1, oct2: @quinto.oct2, otros1: @quinto.otros1, otros2: @quinto.otros2, rem_actual: @quinto.rem_actual, rem_mes: @quinto.rem_mes, rem_proyectada: @quinto.rem_proyectada, renta_bruta: @quinto.renta_bruta, renta_impo1: @quinto.renta_impo1, renta_impo2: @quinto.renta_impo2, renta_impo3: @quinto.renta_impo3, renta_impo4: @quinto.renta_impo4, renta_impo5: @quinto.renta_impo5, renta_impo_ret: @quinto.renta_impo_ret, retencion_mensual: @quinto.retencion_mensual, set1: @quinto.set1, set2: @quinto.set2, total_renta: @quinto.total_renta, total_renta_impo: @quinto.total_renta_impo }
    assert_redirected_to quinto_path(assigns(:quinto))
  end

  test "should destroy quinto" do
    assert_difference('Quinto.count', -1) do
      delete :destroy, id: @quinto
    end

    assert_redirected_to quintos_path
  end
end
