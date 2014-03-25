require 'test_helper'

class LabSceneResourcesControllerTest < ActionController::TestCase
  setup do
    @lab_scene_resource = lab_scene_resources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_scene_resources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_scene_resource" do
    assert_difference('LabSceneResource.count') do
      post :create, lab_scene_resource: { name: @lab_scene_resource.name, play_idle: @lab_scene_resource.play_idle, play_type: @lab_scene_resource.play_type, type: @lab_scene_resource.type }
    end

    assert_redirected_to lab_scene_resource_path(assigns(:lab_scene_resource))
  end

  test "should show lab_scene_resource" do
    get :show, id: @lab_scene_resource
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_scene_resource
    assert_response :success
  end

  test "should update lab_scene_resource" do
    put :update, id: @lab_scene_resource, lab_scene_resource: { name: @lab_scene_resource.name, play_idle: @lab_scene_resource.play_idle, play_type: @lab_scene_resource.play_type, type: @lab_scene_resource.type }
    assert_redirected_to lab_scene_resource_path(assigns(:lab_scene_resource))
  end

  test "should destroy lab_scene_resource" do
    assert_difference('LabSceneResource.count', -1) do
      delete :destroy, id: @lab_scene_resource
    end

    assert_redirected_to lab_scene_resources_path
  end
end
