require 'test_helper'

class LabUsersControllerTest < ActionController::TestCase
  setup do
    @lab_user = lab_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_user" do
    assert_difference('LabUser.count') do
      post :create, lab_user: { account: @lab_user.account, email: @lab_user.email, mobile: @lab_user.mobile, name: @lab_user.name, password: @lab_user.password, role_id: @lab_user.role_id }
    end

    assert_redirected_to lab_user_path(assigns(:lab_user))
  end

  test "should show lab_user" do
    get :show, id: @lab_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_user
    assert_response :success
  end

  test "should update lab_user" do
    put :update, id: @lab_user, lab_user: { account: @lab_user.account, email: @lab_user.email, mobile: @lab_user.mobile, name: @lab_user.name, password: @lab_user.password, role_id: @lab_user.role_id }
    assert_redirected_to lab_user_path(assigns(:lab_user))
  end

  test "should destroy lab_user" do
    assert_difference('LabUser.count', -1) do
      delete :destroy, id: @lab_user
    end

    assert_redirected_to lab_users_path
  end
end
