require 'test_helper'

class SubcontratsControllerTest < ActionController::TestCase
  setup do
    @subcontrat = subcontrats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subcontrats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subcontrat" do
    assert_difference('Subcontrat.count') do
      post :create, subcontrat: { address1: @subcontrat.address1, distrito: @subcontrat.distrito, dpto: @subcontrat.dpto, name: @subcontrat.name, pais: @subcontrat.pais, provincia: @subcontrat.provincia, ruc: @subcontrat.ruc }
    end

    assert_redirected_to subcontrat_path(assigns(:subcontrat))
  end

  test "should show subcontrat" do
    get :show, id: @subcontrat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subcontrat
    assert_response :success
  end

  test "should update subcontrat" do
    patch :update, id: @subcontrat, subcontrat: { address1: @subcontrat.address1, distrito: @subcontrat.distrito, dpto: @subcontrat.dpto, name: @subcontrat.name, pais: @subcontrat.pais, provincia: @subcontrat.provincia, ruc: @subcontrat.ruc }
    assert_redirected_to subcontrat_path(assigns(:subcontrat))
  end

  test "should destroy subcontrat" do
    assert_difference('Subcontrat.count', -1) do
      delete :destroy, id: @subcontrat
    end

    assert_redirected_to subcontrats_path
  end
end
