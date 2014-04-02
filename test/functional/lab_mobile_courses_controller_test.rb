require 'test_helper'

class LabMobileCoursesControllerTest < ActionController::TestCase
  setup do
    @lab_mobile_course = lab_mobile_courses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_mobile_courses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_mobile_course" do
    assert_difference('LabMobileCourse.count') do
      post :create, lab_mobile_course: { author: @lab_mobile_course.author, course_type: @lab_mobile_course.course_type, name: @lab_mobile_course.name, status: @lab_mobile_course.status }
    end

    assert_redirected_to lab_mobile_course_path(assigns(:lab_mobile_course))
  end

  test "should show lab_mobile_course" do
    get :show, id: @lab_mobile_course
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_mobile_course
    assert_response :success
  end

  test "should update lab_mobile_course" do
    put :update, id: @lab_mobile_course, lab_mobile_course: { author: @lab_mobile_course.author, course_type: @lab_mobile_course.course_type, name: @lab_mobile_course.name, status: @lab_mobile_course.status }
    assert_redirected_to lab_mobile_course_path(assigns(:lab_mobile_course))
  end

  test "should destroy lab_mobile_course" do
    assert_difference('LabMobileCourse.count', -1) do
      delete :destroy, id: @lab_mobile_course
    end

    assert_redirected_to lab_mobile_courses_path
  end
end
