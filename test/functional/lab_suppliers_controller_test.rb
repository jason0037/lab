require 'test_helper'

class LabSuppliersControllerTest < ActionController::TestCase
  setup do
    @lab_supplier = lab_suppliers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_suppliers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_supplier" do
    assert_difference('LabSupplier.count') do
      post :create, lab_supplier: { addr: @lab_supplier.addr, contacts: @lab_supplier.contacts, name: @lab_supplier.name, tel: @lab_supplier.tel }
    end

    assert_redirected_to lab_supplier_path(assigns(:lab_supplier))
  end

  test "should show lab_supplier" do
    get :show, id: @lab_supplier
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_supplier
    assert_response :success
  end

  test "should update lab_supplier" do
    put :update, id: @lab_supplier, lab_supplier: { addr: @lab_supplier.addr, contacts: @lab_supplier.contacts, name: @lab_supplier.name, tel: @lab_supplier.tel }
    assert_redirected_to lab_supplier_path(assigns(:lab_supplier))
  end

  test "should destroy lab_supplier" do
    assert_difference('LabSupplier.count', -1) do
      delete :destroy, id: @lab_supplier
    end

    assert_redirected_to lab_suppliers_path
  end
end
