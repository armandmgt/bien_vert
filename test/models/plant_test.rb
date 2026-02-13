require "test_helper"

class PlantTest < ActiveSupport::TestCase
  test "send_watering_reminder_for(user) should notify when plant was not watered ever" do
    users(:one).update(subscriptions: [
      { endpoint: "https://example.com/subscription-one", keys: { p256dh: "", auth: "" } },
      { endpoint: "https://example.com/subscription-two", keys: { p256dh: "", auth: "" } }
    ])
    plants(:one).update(last_watered_at: nil)

    assert_difference "Rpush::Notification.count", 2 do
      Plant.send_watering_reminder_for(users(:one))
    end
  end

  test "send_watering_reminder_for(user) should notify when plant was not watered recently" do
    users(:one).update(subscriptions: [
      { endpoint: "https://example.com/subscription-one", keys: { p256dh: "", auth: "" } },
      { endpoint: "https://example.com/subscription-two", keys: { p256dh: "", auth: "" } }
    ])
    plants(:one).tap { |plant| plant.update(last_watered_at: plant.watering_frequency.days.ago - 1.day) }

    assert_difference "Rpush::Notification.count", 2 do
      Plant.send_watering_reminder_for(users(:one))
    end
  end

  test "send_watering_reminder_for(user) should not notify when plant was watered recently" do
    users(:one).update(subscriptions: [
      { endpoint: "https://example.com/subscription-one", keys: {} },
      { endpoint: "https://example.com/subscription-two", keys: {} }
    ])
    plants(:one).update(last_watered_at: Time.current)

    assert_no_difference "Rpush::Notification.count" do
      Plant.send_watering_reminder_for(users(:one))
    end
  end
end
