require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "should return new password reset page" do
    get new_password_path
    assert_response :success
  end

  test "should send reset password email" do
    assert_enqueued_with(job: ActionMailer::MailDeliveryJob, args: ->(job_args) { job_args.first == PasswordsMailer.to_s }) do
      post passwords_path, params: { email_address: users(:one).email_address }
    end
  end

  test "should not send reset password email when email does not exist" do
    assert_no_enqueued_jobs do
      post passwords_path, params: { email_address: "not_exists@example.com" }
    end
  end

  test "should return password reset page" do
    get edit_password_path(users(:one).password_reset_token)
    assert_response :success
  end

  test "should not return password reset page when link expired" do
    expired_reset_token = nil
    travel_to(16.minutes.ago) { expired_reset_token = users(:one).password_reset_token }

    get edit_password_path(expired_reset_token)
    assert_response :found
  end

  test "should update password" do
    put password_path(users(:one).password_reset_token), params: { password: "new-password", password_confirmation: "new-password" }
    assert_response :found
  end

  test "should not update password when confirmation does not match" do
    put password_path(users(:one).password_reset_token), params: { password: "new-password", password_confirmation: "different-password" }
    assert_response :unprocessable_content
  end
end
