require "test_helper"

class RecognitionRequestsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    login users(:one)
  end

  test "should return recognition request page and enqueue job if pending" do
    assert_enqueued_jobs 1, only: RecognitionJob do
      get recognition_request_path(recognition_requests(:one))
    end
    assert_response :success
  end

  test "should return recognition request page and enqueue nothing if not pending" do
    recognition_requests(:one).update!(state: "running")
    assert_no_enqueued_jobs do
      get recognition_request_path(recognition_requests(:one))
    end
    assert_response :success
  end

  test "should return new recognition request page" do
    get new_recognition_request_path
    assert_response :success
  end

  test "should create a recognition request" do
    assert_difference "users(:one).reload.recognition_requests.count", 1 do
      post recognition_requests_path, params: { recognition_request: { photo: file_fixture_upload("philodendron.jpg", "image/jpg") } }
    end
    assert_redirected_to recognition_request_path(users(:one).reload.recognition_requests.last)
  end

  test "should retry recognition request" do
    assert_enqueued_jobs 1, only: RecognitionJob do
      patch recognition_request_path(recognition_requests(:one)), params: { recognition_request: { state: "pending" } }
    end
    assert_redirected_to recognition_request_path(recognition_requests(:one))
  end
end
