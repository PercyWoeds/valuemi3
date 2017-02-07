require 'test_helper'

class UbicasControllerTest < ActionController::TestCase
  setup do
    @ubica = ubicas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ubicas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ubica" do
    assert_difference('Ubica.count') do
      post :create, ubica: { comments: @ubica.comments, descrip: @ubica.descrip }
    end

    assert_redirected_to ubica_path(assigns(:ubica))
  end

  test "should show ubica" do
    get :show, id: @ubica
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ubica
    assert_response :success
  end

  test "should update ubica" do
    patch :update, id: @ubica, ubica: { comments: @ubica.comments, descrip: @ubica.descrip }
    assert_redirected_to ubica_path(assigns(:ubica))
  end

  test "should destroy ubica" do
    assert_difference('Ubica.count', -1) do
      delete :destroy, id: @ubica
    end

    assert_redirected_to ubicas_path
  end
end
