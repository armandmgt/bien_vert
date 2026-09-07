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

  test "should mark plant as dead" do
    patch plant_path(@plant), params: { plant: { died_at: Time.current } }

    assert_redirected_to root_path
    assert_predicate @plant.reload, :dead?
  end

  test "should revive a dead plant" do
    @plant.update!(died_at: 2.days.ago)

    patch plant_path(@plant), params: { plant: { died_at: "" } }

    assert_redirected_to root_path
    assert_not_predicate @plant.reload, :dead?
  end

  test "should correct the death date of a dead plant" do
    @plant.update!(died_at: 2.days.ago)
    corrected_died_at = 5.days.ago

    patch plant_path(@plant), params: { plant: { died_at: corrected_died_at } }

    assert_redirected_to root_path
    assert_in_delta corrected_died_at, @plant.reload.died_at, 1.second
  end

  test "index should sort dead plants after living ones" do
    dead_plant = users(:one).plants.create!(species: "Fougère", watering_frequency: 3, last_watered_at: 1.year.ago, died_at: 1.month.ago)

    get plants_path

    assert_response :success
    assert_operator response.body.index(dom_id(dead_plant)), :>, response.body.index(dom_id(@plant))
  end

  test "should return edit page of a dead plant with the revive button" do
    @plant.update!(died_at: 2.days.ago)

    get edit_plant_path(@plant)

    assert_response :success
    assert_select "input[type=?][name=?]", "datetime-local", "plant[died_at]"
    assert_select "form[action=?]", plant_path(@plant), text: /Marquer comme vivante/
  end

  test "should return edit page of a living plant with the mark as dead button" do
    get edit_plant_path(@plant)

    assert_response :success
    assert_select "input[type=?][name=?]", "datetime-local", "plant[died_at]", count: 0
    assert_select "form[action=?]", plant_path(@plant), text: /Marquer comme morte/
  end

  test "should mark plant as dead over turbo stream" do
    patch plant_path(@plant), params: { plant: { died_at: Time.current } }, as: :turbo_stream

    assert_response :success
    assert_predicate @plant.reload, :dead?
  end

  test "edit page save button stays associated with the plant form" do
    get edit_plant_path(@plant)

    assert_response :success
    assert_select "form#plant_form[action=?]", plant_path(@plant)
    assert_select "input[type=submit][form=?]", "plant_form"
  end

  test "new page save button stays associated with the plant form" do
    get new_plant_path

    assert_response :success
    assert_select "form#plant_form[action=?]", plants_path
    assert_select "input[type=submit][form=?]", "plant_form"
  end
end
