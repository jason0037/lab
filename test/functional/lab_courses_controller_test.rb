require 'test_helper'

class LabCoursesControllerTest < ActionController::TestCase
  setup do
    @lab_course = lab_courses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_courses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_course" do
    assert_difference('LabCourse.count') do
      post :create, lab_course: { apply_time: @lab_course.apply_time, approve_time: @lab_course.approve_time, before: @lab_course.before, categery_id: @lab_course.categery_id, course_property: @lab_course.course_property, desc: @lab_course.desc, end_time: @lab_course.end_time, is_teach: @lab_course.is_teach, name: @lab_course.name, progress: @lab_course.progress, publish_time: @lab_course.publish_time, report_id: @lab_course.report_id, start_time: @lab_course.start_time, status: @lab_course.status, style: @lab_course.style, teacher_id: @lab_course.teacher_id, type: @lab_course.type }
    end

    assert_redirected_to lab_course_path(assigns(:lab_course))
  end

  test "should show lab_course" do
    get :show, id: @lab_course
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_course
    assert_response :success
  end

  test "should update lab_course" do
    put :update, id: @lab_course, lab_course: { apply_time: @lab_course.apply_time, approve_time: @lab_course.approve_time, before: @lab_course.before, categery_id: @lab_course.categery_id, course_property: @lab_course.course_property, desc: @lab_course.desc, end_time: @lab_course.end_time, is_teach: @lab_course.is_teach, name: @lab_course.name, progress: @lab_course.progress, publish_time: @lab_course.publish_time, report_id: @lab_course.report_id, start_time: @lab_course.start_time, status: @lab_course.status, style: @lab_course.style, teacher_id: @lab_course.teacher_id, type: @lab_course.type }
    assert_redirected_to lab_course_path(assigns(:lab_course))
  end

  test "should destroy lab_course" do
    assert_difference('LabCourse.count', -1) do
      delete :destroy, id: @lab_course
    end

    assert_redirected_to lab_courses_path
  end
end
