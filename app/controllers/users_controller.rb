class UsersController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]

  def new
    redirect_to after_authentication_url, status: :see_other if authenticated?
  end

  def edit
  end

  def create
    user = User.create(create_params)
    if user.valid?
      start_new_session_for user
      redirect_to root_url
    else
      redirect_to new_user_path, alert: user.errors.full_messages.to_sentence
    end
  end

  def update
  end

  def destroy
    user = Current.user
    if user.destroy
      redirect_to root_path, notice: "Votre compte a été supprimé avec succès."
    else
      redirect_to edit_user_path(user), alert: user.errors.full_messages.to_sentence
    end
  end

  private

  def create_params
    params.expect user: [ :email_address, :password ]
  end
end
