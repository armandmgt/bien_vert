require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should return registration page" do
    get new_user_path
    assert_response :success
  end

  test "should redirect when authenticated" do
    login users(:one)
    get new_user_path
    assert_response :see_other
  end

  test "should create user" do
    post users_path, params: { user: { email_address: "create@example.com", password: "password" } }
    assert_response :found
  end

  test "should return profile edit page" do
    login users(:one)
    get edit_user_path(users(:one))
    assert_response :success
  end

  # test "should update user" do
  #   pending
  # end
end
