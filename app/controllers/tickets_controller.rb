class TicketsController < ApplicationController

  # Exécution du ticket
  def execute(ticket)
    session[:ticket_digest] = ticket.digest
    redirection = nil
    if ticket.action.start_with?('/')
      act = ticket.action
      act.index('uid=') || begin
        act += act.index('?') ? '&' : '?'
        act += 'uid=%s' % ticket.user.id.to_s
      end
      redirection = act
    else
      eval(ticket.action)
    end
    ticket.destroy
  rescue Exception => e
    flash[:danger] = e
  ensure
    return redirection
  end

  # Méthode appelée pour jouer le ticket fourni, après vérification
  #
  # Pour utiliser un ticket, on a besoin :
  #   * de l'identifiant du ticket
  #   * du token du ticket
  #
  def run
    # Note : si on ne peut pas le trouver, ça raise ActiveRecord::RecordNotFound
    ticket  = Ticket.find(params[:id])
    token   = params[:token]

    # On peut vérifier que le ticket est bon et n'est pas out fo date
    redirection =
      if ticket_conform?(ticket)
        execute(ticket)
      end || home_path

    # redirect_to(redirection || home_path)
    redirect_to(redirection)

  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = I18n.t('tickets.errors.unknown')
    redirect_to home_path
  end
  # /run

  # Méthode qui retourne TRUE si le ticket et l'utilisateur sont conforme,
  # false dans le cas contraire (et retourne une erreur)
  def ticket_conform?(ticket)
    BCrypt::Password.new(ticket.digest).is_password?(params[:token]) ||
      raise('tickets.errors.invalid')
    !ticket.out_of_date? ||
      raise('tickets.errors.out_of_date')
    params[:uid].blank? || ticket.valid_owner?(current_user, params[:uid]) ||
      raise('tickets.errors.invalid_owner')
    # tout est OK
    return true
  rescue Exception => e
    Flash[:danger] = I18n.t(e.message)
    return false
  end

end
