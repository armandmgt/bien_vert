require "test_helper"

class PlantTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

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

  test "send_watering_reminder_for(user) should not notify when the only overdue plant is dead" do
    users(:one).update(subscriptions: [
      { endpoint: "https://example.com/subscription-one", keys: { p256dh: "", auth: "" } },
      { endpoint: "https://example.com/subscription-two", keys: { p256dh: "", auth: "" } }
    ])
    plants(:one).update(last_watered_at: nil, died_at: Time.current)

    assert_no_difference "Rpush::Notification.count" do
      Plant.send_watering_reminder_for(users(:one))
    end
  end

  test "overdue? should stay true for a dead plant that was not watered recently" do
    plant = plants(:one)
    plant.update(last_watered_at: plant.watering_frequency.days.ago - 1.day, died_at: Time.current)

    assert_predicate plant, :overdue?
  end

  test "needs_watering? should be false for a dead plant however overdue it is" do
    plant = plants(:one)
    plant.update(last_watered_at: nil, died_at: Time.current)

    assert_not_predicate plant, :needs_watering?
  end

  test "needs_watering? should be true again once a dead plant is revived" do
    plant = plants(:one)
    plant.update(last_watered_at: nil, died_at: Time.current)
    plant.update(died_at: nil)

    assert_predicate plant, :needs_watering?
  end

  test "marking a plant dead and reviving it should both refresh the app badges" do
    plant = plants(:one)

    assert_enqueued_with job: RefreshAppBadgesJob, args: [ plant.user ] do
      plant.update(died_at: Time.current)
    end

    assert_enqueued_with job: RefreshAppBadgesJob, args: [ plant.user ] do
      plant.update(died_at: nil)
    end
  end
end
