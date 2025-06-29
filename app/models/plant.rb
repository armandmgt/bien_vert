class Plant < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :species, :watering_frequency, presence: true

  def send_watering_reminder
    return unless last_watered_at.nil? || (last_watered_at + watering_frequency.days).past?

    display_name = name.presence || species.presence
    title = "Rappel d’arrosage"
    body = "C’est l’heure d’arroser #{display_name[0].match?(/[aeiouy]/i) ? "mon" : "ma"} #{display_name}"
    data = {
      path: "/plants/#{id}/edit"
    }

    user.subscriptions.each do |subscription|
      case subscription.symbolize_keys
      in { device_token: }
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
