require "test_helper"

class RecognitionRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get recognition_requests_new_url
    assert_response :success
  end

  test "should get show" do
    get recognition_requests_show_url
    assert_response :success
  end
end
