class SessionsController < ApplicationController

  # Demande d'identification
  def new

  end

  # Créer une session courante (log in)
  def create
    if params[:session]
      user = User.find_by_email(params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        if user.compte_actif?
          flash[:success] = I18n.t('users.success.welcome', name: user.name)
          log_in(user) # dans les helpers de sessions
          params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          redirect_to redirection_after_login(user)
        else
          # Email pas encore confirmé
          flash[:danger] = I18n.t('users.errors.email.not_confirmed', name: user.name)
          # TODO : On pourra joindre une adresse dans le message ci-dessus qui
          # pourra renvoyer le lien de confirmation de l'email (en recherchant
          # l'user et en relevant le ticket avec name: 'activation_compte')
          # NOTE : le token se trouve dans le watcher du ticket, il peut être
          # obtenu simplement en faisant ticket.token. Donc, ticket.url ou
          # lien_vers(ticket) retournera toujours la bonne adresse.
          redirect_to home_path
        end
      else
        flash.now[:danger] = I18n.t('users.errors.login.invalid')
        render :new
      end
    else
      flash[:danger] = I18n.t('users.errors.login.force_tentative')
      redirect_to login_path
    end
  end

  # Détruire la session courante (logout)
  def destroy
    if real_user?
      u = current_user
      log_out
      flash[:success] = I18n.t('users.success.goodbye', name: u.name)
    end
    redirect_to root_path
  end

end
