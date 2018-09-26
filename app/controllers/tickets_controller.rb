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
    token = params[:token]

    redirection = home_path
    # On peut vérifier que le ticket est bon et n'est pas out fo date
    if BCrypt::Password.new(ticket.digest).is_password?(params[:token])
      if ticket.out_of_date?
        flash[:danger] = I18n.t('tickets.errors.out_of_date')
      else
        redirection = execute(ticket)
      end
    else
      flash[:danger] = I18n.t('tickets.errors.invalid')
    end
    redirect_to(redirection || home_path)

  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = I18n.t('tickets.errors.unknown')
    redirect_to home_path
  end
  # /run

end
