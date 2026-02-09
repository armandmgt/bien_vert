require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should return new session page" do
    get new_session_path
    assert_response :success
  end

  test "should redirect when already signed in" do
    login users(:one)
    get new_session_path
    assert_redirected_to root_path
  end

  test "should create new session" do
    post session_path, params: { user: { email_address: users(:one).email_address, password: "password" } }
    assert_redirected_to root_path
  end

  test "should not create session if incorrect password" do
    post session_path, params: { user: { email_address: users(:one).email_address, password: "wrong_password" } }
    assert_redirected_to new_session_path
  end
end
