# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Rpush::Webpush::App.find_or_create_by!(name: "webpush") do |app|
  vapid_keypair = WebPush.generate_key.to_hash
  app.certificate = vapid_keypair.merge(subject: "mailto:armand.megrot@gmail.com").to_json
  app.connections = 1
end

unless Rails.env.test?
  Rpush::Apnsp8::App.find_or_create_by!(name: "apnsp8") do |app|
    app.environment = Rails.env.local? ? :development : :production
    app.apn_key_id = Rails.application.credentials.dig(:apn, :key_id)
    app.apn_key = Base64.decode64(Rails.application.credentials.dig(:apn, :key))
    app.team_id = Rails.application.credentials.dig(:apn, :team_id)
    app.bundle_id = Rails.application.credentials.dig(:apn, :bundle_id)
    app.connections = 1
  end
end
