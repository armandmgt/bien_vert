# Configure ActiveStorage to use proxy mode for serving files
Rails.application.config.active_storage.resolve_model_to_route = :rails_storage_proxy
