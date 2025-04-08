Rpush.configure do |config|
  config.client = :active_record
  config.logger = Rails.logger
  config.foreground_logging = false
end
