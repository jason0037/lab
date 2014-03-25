require 'test_helper'

class LabRolesControllerTest < ActionController::TestCase
  setup do
    @lab_role = lab_roles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_roles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_role" do
    assert_difference('LabRole.count') do
      post :create, lab_role: { name: @lab_role.name }
    end

    assert_redirected_to lab_role_path(assigns(:lab_role))
  end

  test "should show lab_role" do
    get :show, id: @lab_role
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_role
    assert_response :success
  end

  test "should update lab_role" do
    put :update, id: @lab_role, lab_role: { name: @lab_role.name }
    assert_redirected_to lab_role_path(assigns(:lab_role))
  end

  test "should destroy lab_role" do
    assert_difference('LabRole.count', -1) do
      delete :destroy, id: @lab_role
    end

    assert_redirected_to lab_roles_path
  end
end
