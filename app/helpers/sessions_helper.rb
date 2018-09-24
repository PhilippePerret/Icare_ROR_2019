module SessionsHelper

  def current_user
    @current_user ||= get_current_user
  end

  def get_current_user
    if user_id = session[:user_id]
      User.find_by(id: user_id)
    elsif user_id = cookies.signed[:user_id]
      utested = User.find_by(id: user_id)
      if utested && utested.authenticated?(cookies[:remember_token])
        log_in utested
        utested
      end
    end
  end

  # Retourne true s'il y a un user courant
  def current_user?
    !!current_user
  end

  def log_in(user)
    session[:user_id] = user.id
  end
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def store_original_url
    session[:original_url] = request.original_url if request.get?
  end

  # Retourne la route à suivre après l'identification de l'user
  # Pour le moment, on envoie vers le bureau (bureau_path) qui conduit
  # à une page virtuelle
  def redirection_after_login(user)
    if session[:original_url]
      return session.delete(:original_url)
    else
      opt = 1 # option choisie par l'user
      case opt
      when 1 then '/bureau'
      when 2 then '/profil'
      when 3 then '/'
      when 4 then '/last_activites'
        # TODO Mettre les autres path possible
      else
        '/'
      end
    end
  end

end
