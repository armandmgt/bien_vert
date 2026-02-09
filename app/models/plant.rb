class Plant < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :species, :watering_frequency, presence: true

  def needs_watering?
    last_watered_at.nil? || (last_watered_at + watering_frequency.days).past?
  end

  def reminder_criticality
    if Time.current - should_water_at >= watering_frequency.days * 0.5
      :urgent
    else
      :normal
    end
  end

  def should_water_at
    if last_watered_at.nil?
      Time.current
    else
      last_watered_at + watering_frequency.days
    end
  end

  def display_name(with_prefix: false)
    display_name = name.presence || species.presence
    return display_name unless with_prefix

    display_name[0].match?(/[aeiouy]/i) ? "mon #{display_name}" : "ma #{display_name}"
  end

  def send_watering_reminder
    return unless needs_watering?

    title = "Rappel d’arrosage"
    body = "C’est l’heure d’arroser #{display_name(with_prefix: true)}"
    data = {
      path: "/plants/#{id}/edit"
    }

    user.subscriptions.each do |subscription|
      case subscription.deep_symbolize_keys
      in { platform: "ios", deviceToken: device_token }
        Rpush::Apnsp8::Notification.create!(
          app: Rpush::App.find_by_name("apnsp8"),
          device_token: device_token,
          alert: { title: title, body: body },
          data: data,
        )
      in { endpoint: _, keys: { p256dh: _, auth: _ }}
        Rpush::Webpush::Notification.create!(
          app: Rpush::App.find_by_name("webpush"),
          registration_ids: [ subscription.symbolize_keys ],
          data: {
            urgency: "normal",
            message: {
              title: title,
              options: {
                body: body,
                icon: "/icon.png",
                badge: "/icon.png",
                lang: "fr",
                actions: [
                  { action: "view", title: "Voir les plantes" }
                ],
                data: data
              }
            }.to_json
          }
        )
      end
    end

    Rpush.push if Rails.env.local?
  end
end
