class PlantsController < ApplicationController
  before_action :set_plant, only: %i[ edit update destroy ]

  def index
    @plants = Plant.all
  end

  def new
    @plant = Plant.new
  end

  def edit
  end

  def create
    @plant = Plant.new(plant_params.merge(user: Current.user))

    if @plant.save
      redirect_to @plant, notice: "Plant was successfully created."
    else
      flash.now[:alert] = "Plant was not created due to the following errors: #{@plant.errors.full_messages.to_sentence}."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @plant.update(plant_params)
      redirect_to @plant, notice: "Plant was successfully updated.", status: :see_other
    else
      flash.now[:alert] = "Plant was not updated due to the following errors: #{@plant.errors.full_messages.to_sentence}."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plant.destroy!
    redirect_to plants_path, notice: "Plant was successfully destroyed.", status: :see_other
  end

  private

  def set_plant
    @plant = Plant.find(params[:id])
  end

  def plant_params
    params.expect plant: [ :species, :name, :watering_interval_days, :last_watered_at ]
  end
end
