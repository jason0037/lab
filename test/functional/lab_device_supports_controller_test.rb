require 'test_helper'

class LabDeviceSupportsControllerTest < ActionController::TestCase
  setup do
    @lab_device_support = lab_device_supports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_device_supports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_device_support" do
    assert_difference('LabDeviceSupport.count') do
      post :create, lab_device_support: { device_id: @lab_device_support.device_id, rel_id: @lab_device_support.rel_id, type: @lab_device_support.type }
    end

    assert_redirected_to lab_device_support_path(assigns(:lab_device_support))
  end

  test "should show lab_device_support" do
    get :show, id: @lab_device_support
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_device_support
    assert_response :success
  end

  test "should update lab_device_support" do
    put :update, id: @lab_device_support, lab_device_support: { device_id: @lab_device_support.device_id, rel_id: @lab_device_support.rel_id, type: @lab_device_support.type }
    assert_redirected_to lab_device_support_path(assigns(:lab_device_support))
  end

  test "should destroy lab_device_support" do
    assert_difference('LabDeviceSupport.count', -1) do
      delete :destroy, id: @lab_device_support
    end

    assert_redirected_to lab_device_supports_path
  end
end
