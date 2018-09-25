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
    UserMailer.reset_password
  end

end
