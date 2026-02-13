class RefreshAppBadgesJob < ApplicationJob
  def perform(user)
    plants_count = user.plants.filter(&:needs_watering?).count
    user.subscriptions.each do |subscription|
      if subscription.deep_symbolize_keys in { platform: "ios", deviceToken: device_token }
        Rpush::Apnsp8::Notification.create!(
          app: Rpush::App.find_by_name("apnsp8"),
          device_token: device_token,
          badge: plants_count,
        )
      end
    end
  end
end
