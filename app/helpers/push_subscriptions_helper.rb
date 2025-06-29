# frozen_string_literal: true

module PushSubscriptionsHelper
  def needs_new_push_subscription_token
    return false unless Current.user

    Current.user.subscriptions.none? do |subscription|
      subscription["device_token"].present?
    end
  end
end
