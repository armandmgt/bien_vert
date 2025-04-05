# frozen_string_literal: true

class OllamaClient
  @resource = RestClient::Resource.new(
    "http://#{Rails.env.local? ? "127.0.0.1:11434" : "ollama:11434"}",
    { content_type: :json, accept: :json }
  )

  class << self
    delegate_missing_to :@resource
  end
end
