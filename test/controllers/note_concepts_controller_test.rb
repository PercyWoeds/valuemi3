require 'test_helper'

class NoteConceptsControllerTest < ActionController::TestCase
  setup do
    @note_concept = note_concepts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:note_concepts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create note_concept" do
    assert_difference('NoteConcept.count') do
      post :create, note_concept: { code: @note_concept.code, descrip: @note_concept.descrip, td: @note_concept.td }
    end

    assert_redirected_to note_concept_path(assigns(:note_concept))
  end

  test "should show note_concept" do
    get :show, id: @note_concept
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @note_concept
    assert_response :success
  end

  test "should update note_concept" do
    patch :update, id: @note_concept, note_concept: { code: @note_concept.code, descrip: @note_concept.descrip, td: @note_concept.td }
    assert_redirected_to note_concept_path(assigns(:note_concept))
  end

  test "should destroy note_concept" do
    assert_difference('NoteConcept.count', -1) do
      delete :destroy, id: @note_concept
    end

    assert_redirected_to note_concepts_path
  end
end
