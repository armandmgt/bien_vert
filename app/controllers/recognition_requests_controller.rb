class RecognitionRequestsController < ApplicationController
  def show
  end

  def new
  end

  def create
    photo = params.expect(:photo)

    photo = ActiveStorage::Blob.create_and_upload!(io: photo, filename: photo.original_filename, content_type: photo.content_type)
    response = OllamaClient["/api/generate"].post({
      model: "deepseek-r1:14b",
      prompt: "This is a photo of a plant, please identify the species of the plant and output only a JSON object containing a single key 'species'.",
      images: [ Base64.encode64(photo.download) ]
    }.to_json)
    llm_output = response.body.split("\n").reduce("") do |llm_output, chunk|
      llm_output + JSON.parse(chunk)["response"]
    end
    result = JSON.parse(llm_output.gsub(/(```|json|\n)/, ""), symbolize_names: true)
    photo.destroy

    redirect_to recognition_request_path(species: result[:species])
  end
end
