# frozen_string_literal: true

require_relative "../../app/lib/ollama_client"

retries = 0
begin
  OllamaClient["/api/pull"].post({ model: "deepseek-r1:14b" }.to_json)
rescue Errno::ECONNREFUSED
  sleep 1
  retries += 1
  retry if retries < 3
end
