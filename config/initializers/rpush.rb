Rpush.configure do |config|
  config.client = :active_record
  config.push_poll = 2
  config.batch_size = 100
  config.pid_file = Rails.root.join "tmp/rpush.pid"

  config.logger = Rails.logger
  config.foreground_logging = false
end
