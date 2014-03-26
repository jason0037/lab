require 'test_helper'

class LabNoticesControllerTest < ActionController::TestCase
  setup do
    @lab_notice = lab_notices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_notices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_notice" do
    assert_difference('LabNotice.count') do
      post :create, lab_notice: { body: @lab_notice.body, cat_id: @lab_notice.cat_id, published: @lab_notice.published, published_at: @lab_notice.published_at, title: @lab_notice.title }
    end

    assert_redirected_to lab_notice_path(assigns(:lab_notice))
  end

  test "should show lab_notice" do
    get :show, id: @lab_notice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_notice
    assert_response :success
  end

  test "should update lab_notice" do
    put :update, id: @lab_notice, lab_notice: { body: @lab_notice.body, cat_id: @lab_notice.cat_id, published: @lab_notice.published, published_at: @lab_notice.published_at, title: @lab_notice.title }
    assert_redirected_to lab_notice_path(assigns(:lab_notice))
  end

  test "should destroy lab_notice" do
    assert_difference('LabNotice.count', -1) do
      delete :destroy, id: @lab_notice
    end

    assert_redirected_to lab_notices_path
  end
end
