require "test_helper"

class PushSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login users(:one)
  end

  test "should return vapid_key for subscription" do
    get vapid_key_push_subscriptions_path
    assert_response :success
  end

  test "should create a subscription" do
    assert_difference "users(:one).reload.subscriptions.count", 1 do
      post push_subscriptions_path, params: { push_subscription: { endpoint: "https://example.com", expirationTime: 1.month.from_now, keys: { p256dh: SecureRandom.hex(32), auth: SecureRandom.hex(32) } } }
    end
    assert_response :success
  end

  test "should destroy subscription" do
    post push_subscriptions_path, params: { push_subscription: { endpoint: "https://example.com", expirationTime: 1.month.from_now, keys: { p256dh: SecureRandom.hex(32), auth: SecureRandom.hex(32) } } }

    assert_difference "users(:one).reload.subscriptions.count", -1 do
      delete push_subscription_path(0)
    end
    assert_response :success
  end
end
