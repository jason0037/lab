require 'test_helper'

class LabTeachResourcesControllerTest < ActionController::TestCase
  setup do
    @lab_teach_resource = lab_teach_resources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_teach_resources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_teach_resource" do
    assert_difference('LabTeachResource.count') do
      post :create, lab_teach_resource: { author: @lab_teach_resource.author, course_type: @lab_teach_resource.course_type, name: @lab_teach_resource.name, status: @lab_teach_resource.status }
    end

    assert_redirected_to lab_teach_resource_path(assigns(:lab_teach_resource))
  end

  test "should show lab_teach_resource" do
    get :show, id: @lab_teach_resource
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_teach_resource
    assert_response :success
  end

  test "should update lab_teach_resource" do
    put :update, id: @lab_teach_resource, lab_teach_resource: { author: @lab_teach_resource.author, course_type: @lab_teach_resource.course_type, name: @lab_teach_resource.name, status: @lab_teach_resource.status }
    assert_redirected_to lab_teach_resource_path(assigns(:lab_teach_resource))
  end

  test "should destroy lab_teach_resource" do
    assert_difference('LabTeachResource.count', -1) do
      delete :destroy, id: @lab_teach_resource
    end

    assert_redirected_to lab_teach_resources_path
  end
end
