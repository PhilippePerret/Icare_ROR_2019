class SessionsController < ApplicationController

  # Demande d'identification
  def new

  end

  # Créer une session courante (log in)
  def create
    if params[:session]
      user = User.find_by_email(params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        flash[:success] = 'Bienvenue, %s !' % user.name
        log_in(user) # dans les helpers de sessions
        redirect_to user.redirection_after_login
      else
        flash.now[:danger] = 'Adresse mail et/ou mot de passe invalides.'
        render :new
      end
    else
      flash[:danger] = 'Essayeriez-vous de forcer le site ?…'
      redirect_to login_path
    end
  end

  # Détruire la session courante (logout)
  def destroy
    u = current_user
    log_out
    flash[:success] = "À très bientôt, #{u.name} !"
    redirect_to root_path
  end

end
