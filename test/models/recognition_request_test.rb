require "test_helper"

class RecognitionRequestTest < ActiveSupport::TestCase
  test "should reset result when back to pending" do
    recognition_requests(:one).update(state: "completed", result: { species: "Philodendron", watering_frequency: 7 })

    assert_changes "recognition_requests(:one).result", to: {} do
      recognition_requests(:one).update(state: "pending")
    end
  end
end
