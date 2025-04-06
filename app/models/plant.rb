class Plant < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :species, :watering_frequency, presence: true

  def send_watering_reminder
    name = self.name || species
    user.subscriptions.each do |subscription|
      Rpush::Webpush::Notification.create!(
        app: Rpush::App.find_by_name("webpush"),
        registration_ids: [ subscription.symbolize_keys ],
        data: {
          message: {
            title: "Rappel d’arrosage",
            options: {
              body: "C’est l’heure d’arroser #{name[0].match?(/[aeiouy]/i) ? "mon" : "ma"} #{name}",
              icon: "/icon.png",
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
    Rpush.push
  end
end
