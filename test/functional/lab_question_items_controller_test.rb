require 'test_helper'

class LabQuestionItemsControllerTest < ActionController::TestCase
  setup do
    @lab_question_item = lab_question_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_question_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_question_item" do
    assert_difference('LabQuestionItem.count') do
      post :create, lab_question_item: { desc: @lab_question_item.desc, item_index: @lab_question_item.item_index, question_id: @lab_question_item.question_id }
    end

    assert_redirected_to lab_question_item_path(assigns(:lab_question_item))
  end

  test "should show lab_question_item" do
    get :show, id: @lab_question_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_question_item
    assert_response :success
  end

  test "should update lab_question_item" do
    put :update, id: @lab_question_item, lab_question_item: { desc: @lab_question_item.desc, item_index: @lab_question_item.item_index, question_id: @lab_question_item.question_id }
    assert_redirected_to lab_question_item_path(assigns(:lab_question_item))
  end

  test "should destroy lab_question_item" do
    assert_difference('LabQuestionItem.count', -1) do
      delete :destroy, id: @lab_question_item
    end

    assert_redirected_to lab_question_items_path
  end
end
