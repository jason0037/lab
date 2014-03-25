require 'test_helper'

class LabCourseStudentsControllerTest < ActionController::TestCase
  setup do
    @lab_course_student = lab_course_students(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_course_students)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_course_student" do
    assert_difference('LabCourseStudent.count') do
      post :create, lab_course_student: { course_id: @lab_course_student.course_id, status: @lab_course_student.status, user_id: @lab_course_student.user_id }
    end

    assert_redirected_to lab_course_student_path(assigns(:lab_course_student))
  end

  test "should show lab_course_student" do
    get :show, id: @lab_course_student
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_course_student
    assert_response :success
  end

  test "should update lab_course_student" do
    put :update, id: @lab_course_student, lab_course_student: { course_id: @lab_course_student.course_id, status: @lab_course_student.status, user_id: @lab_course_student.user_id }
    assert_redirected_to lab_course_student_path(assigns(:lab_course_student))
  end

  test "should destroy lab_course_student" do
    assert_difference('LabCourseStudent.count', -1) do
      delete :destroy, id: @lab_course_student
    end

    assert_redirected_to lab_course_students_path
  end
end
