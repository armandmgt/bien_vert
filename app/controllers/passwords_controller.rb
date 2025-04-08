class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if (user = User.find_by(email_address: params[:email_address]))
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: "Les instructions pour mettre à jour votre mot de passe ont été envoyées (si votre compte existe)."
  end

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: "Votre mot de passe a bien été mis à jour."
    else
      redirect_to edit_password_path(params[:token]), status: :unprocessable_content, alert: "La confirmation de mot de passe ne correspond pas."
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: "Le lien a expiré."
    end
end
