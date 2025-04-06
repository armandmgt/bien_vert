class Plant < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :species, :watering_frequency, presence: true

  def send_watering_reminder
    return unless last_watered_at.nil? || (last_watered_at + watering_frequency.days).past?

    display_name = name || species
    user.subscriptions.each do |subscription|
      Rpush::Webpush::Notification.create!(
        app: Rpush::App.find_by_name("webpush"),
        registration_ids: [ subscription.symbolize_keys ],
        data: {
          urgency: "normal",
          message: {
            title: "Rappel d’arrosage",
            options: {
              body: "C’est l’heure d’arroser #{display_name[0].match?(/[aeiouy]/i) ? "mon" : "ma"} #{display_name}",
              icon: "/icon.png",
              badge: "/icon.png",
              lang: "fr",
              actions: [
                { action: "view", title: "Voir les plantes" }
              ],
              data: {
                path: "/plants/#{id}/edit"
              }
            }
          }.to_json
        }
      )
    end

    Rpush.push if Rails.env.local?
  end
end
