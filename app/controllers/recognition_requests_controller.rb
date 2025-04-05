class RecognitionRequestsController < ApplicationController
  before_action :set_recognition_request, only: [ :show, :update ]

  def show
    RecognitionJob.perform_later(@recognition_request) if @recognition_request.pending?
  end

  def new
    @recognition_request = RecognitionRequest.new
  end

  def create
    @recognition_request = RecognitionRequest.new(create_params.merge(user: Current.user))

    if @recognition_request.save
      redirect_to @recognition_request, notice: "Recognition request was successfully created."
    else
      flash.now[:alert] = "Recognition request was not created due to the following errors: #{@recognition_request.errors.full_messages.to_sentence}."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @recognition_request.update(update_params)
      RecognitionJob.perform_later(@recognition_request) if @recognition_request.pending?
      redirect_to @recognition_request, notice: "Recognition request was successfully updated."
    else
      flash.now[:alert] = "Recognition request was not updated due to the following errors: #{@recognition_request.errors.full_messages.to_sentence}."
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_recognition_request
    @recognition_request = RecognitionRequest.find(params[:id])
  end

  def create_params
    params.expect recognition_request: [ :photo ]
  end

  def update_params
    params.expect recognition_request: [ :state, :result ]
  end
end
