class PasswordResetsController < ApplicationController
  def new
  end

  # Création et envoi du ticket pour réinitialiser le mot de passe
  def create
    # Si l'adresse existe, on prend l'user et on lui fait un ticket.
    u = User.find_by(email: params[:infopassword][:email])
    u || raise(ActiveRecord::RecordNotFound)
    ticket = Ticket.new(
      name:    'reset_password',
      action:  '/password_resets/%{token}/edit',
      duree:   2.hours
      )
    ticket = u.tickets.create(ticket.hash_to_create)
    UserMailer.reset_password(u, ticket).deliver_now
    flash[:success] = I18n.t('email.success.mail_reset_sent', email: u.email)
  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = I18n.t('users.errors.email.unknown')
  ensure
    redirect_to home_path + ('?urltry=%s' % ticket_run_url(ticket.id, token: ticket.token))
  end

  # Offrir un formulaire pour entrer un nouveau mot de passe
  def edit
    @user   = User.find(params[:uid])
    @digest = session[:ticket_digest]
    if BCrypt::Password.new(@digest).is_password?(params[:id])
      # On peut procéder au changement
    else
      flash[:danger] = I18n.t('password.errors.reset_not_allowed')
      redirect_to home_path
    end

    # TODO : On pourrait mettre une date d'expiration dans l'enregistrement
    # avec une valeur par défaut.
  end

  # Enregistrer le nouveau mot de passe et logguer l'user
  def update
    @user   = User.find(params[:id])
    pwd     = params[:newpass][:password].strip
    pwdconf = params[:newpass][:password_confirmation].strip
    if pwd == pwdconf
      # => OK
      @user.update_attribute(:password_digest, SessionsHelper.digest(pwd))
      log_in(@user)
      flash[:success] = I18n.t('password.success.reset', {pseudo: @user.name})
      redirect_to home_path
    else
      # => Ne correspond pas
      flash.now[:danger] = I18n.t('password.errors.confirmation_doesnt_match')
      render :edit
    end
  end

end
