require 'test_helper'

class AfpsControllerTest < ActionController::TestCase
  setup do
    @afp = afps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:afps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create afp" do
    assert_difference('Afp.count') do
      post :create, afp: { company_id: @afp.company_id, name: @afp.name }
    end

    assert_redirected_to afp_path(assigns(:afp))
  end

  test "should show afp" do
    get :show, id: @afp
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @afp
    assert_response :success
  end

  test "should update afp" do
    patch :update, id: @afp, afp: { company_id: @afp.company_id, name: @afp.name }
    assert_redirected_to afp_path(assigns(:afp))
  end

  test "should destroy afp" do
    assert_difference('Afp.count', -1) do
      delete :destroy, id: @afp
    end

    assert_redirected_to afps_path
  end
end
