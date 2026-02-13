class PlantsController < ApplicationController
  before_action :set_plant, only: %i[ edit update destroy ]

  def index
    @plants = Current.user.plants.all.sort_by(&:should_water_at)
  end

  def new
    @plant = Plant.new
  end

  def edit
  end

  def create
    @plant = Plant.new(plant_params.merge(user: Current.user, photo: params.dig(:plant, :photo_blob_id)&.then { ActiveStorage::Blob.find(_1) }))

    if @plant.save
      redirect_to root_path, notice: "Plant was successfully created."
    else
      flash.now[:alert] = "Plant was not created due to the following errors: #{@plant.errors.full_messages.to_sentence}."
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @plant.update(plant_params)
      redirect_to root_path, notice: "Plant was successfully updated.", status: :see_other
    else
      flash.now[:alert] = "Plant was not updated due to the following errors: #{@plant.errors.full_messages.to_sentence}."
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @plant.destroy!
    redirect_to root_path, notice: "Plant was successfully destroyed.", status: :see_other
  end

  private

  def set_plant
    @plant = Current.user.plants.find(params[:id])
  end

  def plant_params
    params.expect plant: [ :species, :name, :watering_frequency, :last_watered_at ]
  end
end
