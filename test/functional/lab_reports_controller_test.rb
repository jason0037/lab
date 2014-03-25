require 'test_helper'

class LabReportsControllerTest < ActionController::TestCase
  setup do
    @lab_report = lab_reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_report" do
    assert_difference('LabReport.count') do
      post :create, lab_report: { child_report_index: @lab_report.child_report_index, desc: @lab_report.desc, name: @lab_report.name, parent_report_id: @lab_report.parent_report_id }
    end

    assert_redirected_to lab_report_path(assigns(:lab_report))
  end

  test "should show lab_report" do
    get :show, id: @lab_report
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_report
    assert_response :success
  end

  test "should update lab_report" do
    put :update, id: @lab_report, lab_report: { child_report_index: @lab_report.child_report_index, desc: @lab_report.desc, name: @lab_report.name, parent_report_id: @lab_report.parent_report_id }
    assert_redirected_to lab_report_path(assigns(:lab_report))
  end

  test "should destroy lab_report" do
    assert_difference('LabReport.count', -1) do
      delete :destroy, id: @lab_report
    end

    assert_redirected_to lab_reports_path
  end
end
