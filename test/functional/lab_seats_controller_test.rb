require 'test_helper'

class LabSeatsControllerTest < ActionController::TestCase
  setup do
    @lab_seat = lab_seats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lab_seats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lab_seat" do
    assert_difference('LabSeat.count') do
      post :create, lab_seat: { course_id: @lab_seat.course_id, seat_index: @lab_seat.seat_index, user_id: @lab_seat.user_id }
    end

    assert_redirected_to lab_seat_path(assigns(:lab_seat))
  end

  test "should show lab_seat" do
    get :show, id: @lab_seat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lab_seat
    assert_response :success
  end

  test "should update lab_seat" do
    put :update, id: @lab_seat, lab_seat: { course_id: @lab_seat.course_id, seat_index: @lab_seat.seat_index, user_id: @lab_seat.user_id }
    assert_redirected_to lab_seat_path(assigns(:lab_seat))
  end

  test "should destroy lab_seat" do
    assert_difference('LabSeat.count', -1) do
      delete :destroy, id: @lab_seat
    end

    assert_redirected_to lab_seats_path
  end
end
