class RecognitionRequest < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  enum :state, {
    pending: "pending",
    running: "running",
    completed: "completed",
    failed: "failed"
  }

  store :result, accessors: [ :species, :watering_frequency ]

  before_save do |recognition_request|
    recognition_request.result = nil if recognition_request.state_changed?(to: :pending)
  end

  broadcasts
end
