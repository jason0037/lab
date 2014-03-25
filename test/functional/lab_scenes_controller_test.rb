require 'test_helper'

class LabScenesControllerTest < ActionController::TestCase
  setup do
    @lab_scene = lab_scenes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_scenes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_scene" do
    assert_difference('LabScene.count') do
      post :create, lab_scene: { desc: @lab_scene.desc, limit: @lab_scene.limit, name: @lab_scene.name, secens_resource_id: @lab_scene.secens_resource_id }
    end

    assert_redirected_to lab_scene_path(assigns(:lab_scene))
  end

  test "should show lab_scene" do
    get :show, id: @lab_scene
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_scene
    assert_response :success
  end

  test "should update lab_scene" do
    put :update, id: @lab_scene, lab_scene: { desc: @lab_scene.desc, limit: @lab_scene.limit, name: @lab_scene.name, secens_resource_id: @lab_scene.secens_resource_id }
    assert_redirected_to lab_scene_path(assigns(:lab_scene))
  end

  test "should destroy lab_scene" do
    assert_difference('LabScene.count', -1) do
      delete :destroy, id: @lab_scene
    end

    assert_redirected_to lab_scenes_path
  end
end
