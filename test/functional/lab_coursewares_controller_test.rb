require 'test_helper'

class LabCoursewaresControllerTest < ActionController::TestCase
  setup do
    @lab_courseware = lab_coursewares(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_coursewares)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_courseware" do
    assert_difference('LabCourseware.count') do
      post :create, lab_courseware: { course_id: @lab_courseware.course_id, download_times: @lab_courseware.download_times, download_url: @lab_courseware.download_url, file_size: @lab_courseware.file_size, name: @lab_courseware.name, play_time: @lab_courseware.play_time, product_time: @lab_courseware.product_time, productor_id: @lab_courseware.productor_id, publish_time: @lab_courseware.publish_time, type: @lab_courseware.type }
    end

    assert_redirected_to lab_courseware_path(assigns(:lab_courseware))
  end

  test "should show lab_courseware" do
    get :show, id: @lab_courseware
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_courseware
    assert_response :success
  end

  test "should update lab_courseware" do
    put :update, id: @lab_courseware, lab_courseware: { course_id: @lab_courseware.course_id, download_times: @lab_courseware.download_times, download_url: @lab_courseware.download_url, file_size: @lab_courseware.file_size, name: @lab_courseware.name, play_time: @lab_courseware.play_time, product_time: @lab_courseware.product_time, productor_id: @lab_courseware.productor_id, publish_time: @lab_courseware.publish_time, type: @lab_courseware.type }
    assert_redirected_to lab_courseware_path(assigns(:lab_courseware))
  end

  test "should destroy lab_courseware" do
    assert_difference('LabCourseware.count', -1) do
      delete :destroy, id: @lab_courseware
    end

    assert_redirected_to lab_coursewares_path
  end
end
