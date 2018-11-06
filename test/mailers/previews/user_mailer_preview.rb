# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/activation_compte
  def activation_compte
    # UserMailer.activation_compte
    user = User.first
    user.create_activation_digest
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/reset_password
  def reset_password
    user = User.first
    ticket = user.tickets.create(
        name:     'Réinitialiser le mot de passe',
        action:   '/password_resets/%{token}/edit',
        duree:    2.days
    )
    UserMailer.reset_password(user, ticket)
  end

end
