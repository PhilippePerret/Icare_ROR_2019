module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    @current_user === nil && begin
      if session[:user_id]
        User.find_by(id: session[:user_id])
      else
        false
      end
    end
  end

  # Retourne true s'il y a un user courant
  def current_user?
    !!current_user
  end

end
