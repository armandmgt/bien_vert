class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: "Changement de mot de passe", to: user.email_address
  end
end
