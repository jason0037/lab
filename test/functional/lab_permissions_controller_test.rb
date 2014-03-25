require 'test_helper'

class LabPermissionsControllerTest < ActionController::TestCase
  setup do
    @lab_permission = lab_permissions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_permissions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_permission" do
    assert_difference('LabPermission.count') do
      post :create, lab_permission: { key: @lab_permission.key, name: @lab_permission.name, url: @lab_permission.url }
    end

    assert_redirected_to lab_permission_path(assigns(:lab_permission))
  end

  test "should show lab_permission" do
    get :show, id: @lab_permission
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_permission
    assert_response :success
  end

  test "should update lab_permission" do
    put :update, id: @lab_permission, lab_permission: { key: @lab_permission.key, name: @lab_permission.name, url: @lab_permission.url }
    assert_redirected_to lab_permission_path(assigns(:lab_permission))
  end

  test "should destroy lab_permission" do
    assert_difference('LabPermission.count', -1) do
      delete :destroy, id: @lab_permission
    end

    assert_redirected_to lab_permissions_path
  end
end
