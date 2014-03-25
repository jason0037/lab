require 'test_helper'

class LabEquipmentsControllerTest < ActionController::TestCase
  setup do
    @lab_equipment = lab_equipments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_equipments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_equipment" do
    assert_difference('LabEquipment.count') do
      post :create, lab_equipment: { equipment_code: @lab_equipment.equipment_code, install_time: @lab_equipment.install_time, name: @lab_equipment.name, position: @lab_equipment.position, status: @lab_equipment.status }
    end

    assert_redirected_to lab_equipment_path(assigns(:lab_equipment))
  end

  test "should show lab_equipment" do
    get :show, id: @lab_equipment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_equipment
    assert_response :success
  end

  test "should update lab_equipment" do
    put :update, id: @lab_equipment, lab_equipment: { equipment_code: @lab_equipment.equipment_code, install_time: @lab_equipment.install_time, name: @lab_equipment.name, position: @lab_equipment.position, status: @lab_equipment.status }
    assert_redirected_to lab_equipment_path(assigns(:lab_equipment))
  end

  test "should destroy lab_equipment" do
    assert_difference('LabEquipment.count', -1) do
      delete :destroy, id: @lab_equipment
    end

    assert_redirected_to lab_equipments_path
  end
end
