class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Veuillez re-essayer plus tard." }

  def new
    redirect_to after_authentication_url if authenticated?
  end

  def create
    if (user = User.authenticate_by(params.expect(user: [ :email_address, :password ]))) && user.approved?
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Email ou mot de passe incorrect."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
