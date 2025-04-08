require "test_helper"

class PlantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login users(:one)
    @plant = plants(:one)
  end

  test "should return index page" do
    get plants_path
    assert_response :success
  end

  test "should return new plant page" do
    get new_plant_path
    assert_response :success
  end

  test "should create plant" do
    assert_difference("Plant.count") do
      post plants_path, params: { plant: { user_id: @plant.user_id, species: @plant.species, name: @plant.name, watering_frequency: @plant.watering_frequency, last_watered_at: @plant.last_watered_at } }
    end

    assert_redirected_to root_path
  end

  test "should return edit plant page" do
    get edit_plant_path(@plant)
    assert_response :success
  end

  test "should update plant" do
    patch plant_path(@plant), params: { plant: { name: "new-name", last_watered_at: Time.current } }
    assert_redirected_to root_path
  end

  test "should destroy plant" do
    assert_difference("Plant.count", -1) do
      delete plant_path(@plant)
    end

    assert_redirected_to root_path
  end
end
