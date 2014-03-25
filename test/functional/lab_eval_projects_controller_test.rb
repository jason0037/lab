require 'test_helper'

class LabEvalProjectsControllerTest < ActionController::TestCase
  setup do
    @lab_eval_project = lab_eval_projects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_eval_projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_eval_project" do
    assert_difference('LabEvalProject.count') do
      post :create, lab_eval_project: { categery_id: @lab_eval_project.categery_id, course_type: @lab_eval_project.course_type, name: @lab_eval_project.name, scene_id: @lab_eval_project.scene_id, status: @lab_eval_project.status, supplier_id: @lab_eval_project.supplier_id, version: @lab_eval_project.version }
    end

    assert_redirected_to lab_eval_project_path(assigns(:lab_eval_project))
  end

  test "should show lab_eval_project" do
    get :show, id: @lab_eval_project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_eval_project
    assert_response :success
  end

  test "should update lab_eval_project" do
    put :update, id: @lab_eval_project, lab_eval_project: { categery_id: @lab_eval_project.categery_id, course_type: @lab_eval_project.course_type, name: @lab_eval_project.name, scene_id: @lab_eval_project.scene_id, status: @lab_eval_project.status, supplier_id: @lab_eval_project.supplier_id, version: @lab_eval_project.version }
    assert_redirected_to lab_eval_project_path(assigns(:lab_eval_project))
  end

  test "should destroy lab_eval_project" do
    assert_difference('LabEvalProject.count', -1) do
      delete :destroy, id: @lab_eval_project
    end

    assert_redirected_to lab_eval_projects_path
  end
end
