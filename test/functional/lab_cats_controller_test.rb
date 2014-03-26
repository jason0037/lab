require 'test_helper'

class LabCatsControllerTest < ActionController::TestCase
  setup do
    @lab_cat = lab_cats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_cats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_cat" do
    assert_difference('LabCat.count') do
      post :create, lab_cat: { cat_name: @lab_cat.cat_name, disabled: @lab_cat.disabled, parent_id: @lab_cat.parent_id }
    end

    assert_redirected_to lab_cat_path(assigns(:lab_cat))
  end

  test "should show lab_cat" do
    get :show, id: @lab_cat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_cat
    assert_response :success
  end

  test "should update lab_cat" do
    put :update, id: @lab_cat, lab_cat: { cat_name: @lab_cat.cat_name, disabled: @lab_cat.disabled, parent_id: @lab_cat.parent_id }
    assert_redirected_to lab_cat_path(assigns(:lab_cat))
  end

  test "should destroy lab_cat" do
    assert_difference('LabCat.count', -1) do
      delete :destroy, id: @lab_cat
    end

    assert_redirected_to lab_cats_path
  end
end
