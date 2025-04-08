class UsersController < ApplicationController
  allow_unauthenticated_access

  def new
    redirect_to after_authentication_url, status: :see_other if authenticated?
  end

  def edit
  end

  def create
    user = User.create(create_params)
    if user.valid?
      start_new_session_for user
      redirect_to edit_user_path(user, onboarding: true)
    else
      redirect_to new_user_path, alert: user.errors.full_messages.to_sentence
    end
  end

  def update
  end

  private

  def create_params
    params.expect user: [ :email_address, :password ]
  end
end
