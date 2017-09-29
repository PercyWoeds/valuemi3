require 'test_helper'

class DatoLawsControllerTest < ActionController::TestCase
  setup do
    @dato_law = dato_laws(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dato_laws)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dato_law" do
    assert_difference('DatoLaw.count') do
      post :create, dato_law: { a_familiar: @dato_law.a_familiar, accidente_trabajo: @dato_law.accidente_trabajo, afp_id: @dato_law.afp_id, comision: @dato_law.comision, contrato_fin: @dato_law.contrato_fin, contrato_inicio: @dato_law.contrato_inicio, cussp: @dato_law.cussp, descuento_ley: @dato_law.descuento_ley, descuento_quinta: @dato_law.descuento_quinta, domiciliado: @dato_law.domiciliado, employee_id: @dato_law.employee_id, grati_diciembre: @dato_law.grati_diciembre, grati_julio: @dato_law.grati_julio, ies: @dato_law.ies, importe_subsidio: @dato_law.importe_subsidio, no_afecto: @dato_law.no_afecto, no_afecto_afp: @dato_law.no_afecto_afp, no_afecto_grati: @dato_law.no_afecto_grati, otra_ley_social: @dato_law.otra_ley_social, regimen_id: @dato_law.regimen_id, senati: @dato_law.senati, sobretiempo: @dato_law.sobretiempo, sueldo_integral: @dato_law.sueldo_integral, tipo_afiliado_id: @dato_law.tipo_afiliado_id, vacaciones_fin: @dato_law.vacaciones_fin, vacaciones_inicio: @dato_law.vacaciones_inicio }
    end

    assert_redirected_to dato_law_path(assigns(:dato_law))
  end

  test "should show dato_law" do
    get :show, id: @dato_law
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dato_law
    assert_response :success
  end

  test "should update dato_law" do
    patch :update, id: @dato_law, dato_law: { a_familiar: @dato_law.a_familiar, accidente_trabajo: @dato_law.accidente_trabajo, afp_id: @dato_law.afp_id, comision: @dato_law.comision, contrato_fin: @dato_law.contrato_fin, contrato_inicio: @dato_law.contrato_inicio, cussp: @dato_law.cussp, descuento_ley: @dato_law.descuento_ley, descuento_quinta: @dato_law.descuento_quinta, domiciliado: @dato_law.domiciliado, employee_id: @dato_law.employee_id, grati_diciembre: @dato_law.grati_diciembre, grati_julio: @dato_law.grati_julio, ies: @dato_law.ies, importe_subsidio: @dato_law.importe_subsidio, no_afecto: @dato_law.no_afecto, no_afecto_afp: @dato_law.no_afecto_afp, no_afecto_grati: @dato_law.no_afecto_grati, otra_ley_social: @dato_law.otra_ley_social, regimen_id: @dato_law.regimen_id, senati: @dato_law.senati, sobretiempo: @dato_law.sobretiempo, sueldo_integral: @dato_law.sueldo_integral, tipo_afiliado_id: @dato_law.tipo_afiliado_id, vacaciones_fin: @dato_law.vacaciones_fin, vacaciones_inicio: @dato_law.vacaciones_inicio }
    assert_redirected_to dato_law_path(assigns(:dato_law))
  end

  test "should destroy dato_law" do
    assert_difference('DatoLaw.count', -1) do
      delete :destroy, id: @dato_law
    end

    assert_redirected_to dato_laws_path
  end
end
