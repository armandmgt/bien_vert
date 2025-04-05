# frozen_string_literal: true

class RecognitionJob < ApplicationJob
  def perform(photo)
    response = OllamaClient["/api/generate"].post({
      model: "llava",
      prompt: "This is a photo of a plant, please identify the species of the plant and output only a JSON object containing a single key 'species'.",
      images: [ Base64.encode64(photo.download) ]
    }.to_json)
    llm_output = response.body.split("\n").reduce("") do |llm_output, chunk|
      llm_output + JSON.parse(chunk)["response"]
    end
    pp JSON.parse(llm_output.gsub(/(```|json|\n)/, ""))
    photo.destroy
  end
end
