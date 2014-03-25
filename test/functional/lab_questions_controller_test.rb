require 'test_helper'

class LabQuestionsControllerTest < ActionController::TestCase
  setup do
    @lab_question = lab_questions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_questions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_question" do
    assert_difference('LabQuestion.count') do
      post :create, lab_question: { answer_id: @lab_question.answer_id, question: @lab_question.question, report_id: @lab_question.report_id, report_index: @lab_question.report_index }
    end

    assert_redirected_to lab_question_path(assigns(:lab_question))
  end

  test "should show lab_question" do
    get :show, id: @lab_question
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_question
    assert_response :success
  end

  test "should update lab_question" do
    put :update, id: @lab_question, lab_question: { answer_id: @lab_question.answer_id, question: @lab_question.question, report_id: @lab_question.report_id, report_index: @lab_question.report_index }
    assert_redirected_to lab_question_path(assigns(:lab_question))
  end

  test "should destroy lab_question" do
    assert_difference('LabQuestion.count', -1) do
      delete :destroy, id: @lab_question
    end

    assert_redirected_to lab_questions_path
  end
end
