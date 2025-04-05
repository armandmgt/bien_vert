# frozen_string_literal: true

class RecognitionJob < ApplicationJob
  def perform(recognition_request)
    recognition_request.update(state: "running")
    response = OpenAI::Client.new.responses.create(parameters: {
      model: "gpt-4o",
      text: { format: OUTPUT_SCHEMA },
      input: prompt(recognition_request.photo)
    })
    json_result = JSON.parse(response.dig("output", 0, "content", 0, "text"))
    recognition_request.update(state: "completed", result: json_result)
  rescue Faraday::ClientError => e
    Rails.logger.error(e.response)
    recognition_request.update(state: "failed", result: { response_status: e.response_status, response_body: e.response_body })
  rescue StandardError => e
    Rails.logger.error(e)
    recognition_request.update(state: "failed", result: { exception: e.class, message: e.message, backtrace: Rails.backtrace_cleaner.clean(e.backtrace) })
  end

  private

  OUTPUT_SCHEMA = {
    type: "json_schema",
    name: "recognition_result",
    strict: true,
    schema: {
      type: "object",
      properties: {
        species: {
          type: "string",
          description: "The species of the plant."
        },
        watering_frequency: {
          type: "number",
          description: "The recommended watering frequency of the plant in days."
        }
      },
      required: %w[species watering_frequency],
      additionalProperties: false
    }
  }.freeze
  private_constant :OUTPUT_SCHEMA

  def prompt(image)
    [
      {
        role: "user",
        content: [
          {
            type: "input_image",
            image_url: "data:#{image.content_type};base64,#{Base64.encode64(image.variant(resize_to_limit: [ 2000, 768 ]).processed.download)}"
          },
          {
            type: "input_text",
            text: "Identify the species of this plant."
          }
        ]
      }
    ]
  end
end
