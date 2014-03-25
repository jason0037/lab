require 'test_helper'

class LabDevicesControllerTest < ActionController::TestCase
  setup do
    @lab_device = lab_devices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_devices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_device" do
    assert_difference('LabDevice.count') do
      post :create, lab_device: { name: @lab_device.name, version: @lab_device.version }
    end

    assert_redirected_to lab_device_path(assigns(:lab_device))
  end

  test "should show lab_device" do
    get :show, id: @lab_device
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_device
    assert_response :success
  end

  test "should update lab_device" do
    put :update, id: @lab_device, lab_device: { name: @lab_device.name, version: @lab_device.version }
    assert_redirected_to lab_device_path(assigns(:lab_device))
  end

  test "should destroy lab_device" do
    assert_difference('LabDevice.count', -1) do
      delete :destroy, id: @lab_device
    end

    assert_redirected_to lab_devices_path
  end
end
