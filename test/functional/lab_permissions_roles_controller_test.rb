require 'test_helper'

class LabPermissionsRolesControllerTest < ActionController::TestCase
  setup do
    @lab_permissions_role = lab_permissions_roles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_permissions_roles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_permissions_role" do
    assert_difference('LabPermissionsRole.count') do
      post :create, lab_permissions_role: { permission_id: @lab_permissions_role.permission_id, role_id: @lab_permissions_role.role_id }
    end

    assert_redirected_to lab_permissions_role_path(assigns(:lab_permissions_role))
  end

  test "should show lab_permissions_role" do
    get :show, id: @lab_permissions_role
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_permissions_role
    assert_response :success
  end

  test "should update lab_permissions_role" do
    put :update, id: @lab_permissions_role, lab_permissions_role: { permission_id: @lab_permissions_role.permission_id, role_id: @lab_permissions_role.role_id }
    assert_redirected_to lab_permissions_role_path(assigns(:lab_permissions_role))
  end

  test "should destroy lab_permissions_role" do
    assert_difference('LabPermissionsRole.count', -1) do
      delete :destroy, id: @lab_permissions_role
    end

    assert_redirected_to lab_permissions_roles_path
  end
end
