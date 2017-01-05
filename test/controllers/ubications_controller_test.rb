require 'test_helper'

class UbicationsControllerTest < ActionController::TestCase
  setup do
    @ubication = ubications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ubications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ubication" do
    assert_difference('Ubication.count') do
      post :create, ubication: { company_id: @ubication.company_id, descrip: @ubication.descrip }
    end

    assert_redirected_to ubication_path(assigns(:ubication))
  end

  test "should show ubication" do
    get :show, id: @ubication
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ubication
    assert_response :success
  end

  test "should update ubication" do
    patch :update, id: @ubication, ubication: { company_id: @ubication.company_id, descrip: @ubication.descrip }
    assert_redirected_to ubication_path(assigns(:ubication))
  end

  test "should destroy ubication" do
    assert_difference('Ubication.count', -1) do
      delete :destroy, id: @ubication
    end

    assert_redirected_to ubications_path
  end
end
