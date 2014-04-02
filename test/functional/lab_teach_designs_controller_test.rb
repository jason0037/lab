require 'test_helper'

class LabTeachDesignsControllerTest < ActionController::TestCase
  setup do
    @lab_teach_design = lab_teach_designs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_teach_designs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_teach_design" do
    assert_difference('LabTeachDesign.count') do
      post :create, lab_teach_design: { author: @lab_teach_design.author, course_type: @lab_teach_design.course_type, name: @lab_teach_design.name, status: @lab_teach_design.status }
    end

    assert_redirected_to lab_teach_design_path(assigns(:lab_teach_design))
  end

  test "should show lab_teach_design" do
    get :show, id: @lab_teach_design
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_teach_design
    assert_response :success
  end

  test "should update lab_teach_design" do
    put :update, id: @lab_teach_design, lab_teach_design: { author: @lab_teach_design.author, course_type: @lab_teach_design.course_type, name: @lab_teach_design.name, status: @lab_teach_design.status }
    assert_redirected_to lab_teach_design_path(assigns(:lab_teach_design))
  end

  test "should destroy lab_teach_design" do
    assert_difference('LabTeachDesign.count', -1) do
      delete :destroy, id: @lab_teach_design
    end

    assert_redirected_to lab_teach_designs_path
  end
end
