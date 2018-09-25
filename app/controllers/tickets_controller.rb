class TicketsController < ApplicationController

  # Méthode appelée pour jouer le ticket fourni, après vérification
  #
  # Pour utiliser un ticket, on a besoin :
  #   * de l'identifiant du ticket
  #   * du token du ticket
  #
  def run

    # Note : si on ne peut pas le trouver, ça raise ActiveRecord::RecordNotFound
    ticket  = Ticket.find(params[:id])

    # On peut vérifier
    if BCrypt::Password.new(ticket.digest) == params[:token]
      begin
        eval ticket.action
      rescue Exception => e
        flash[:danger] = e
      else
        ticket.destroy
      end
    else
      flash[:danger] = I18n.t('tickets.errors.invalid')
    end

  rescue ActiveRecord::RecordNotFound => e
    flash[:danger] = I18n.t('tickets.errors.unknown')
  ensure
    redirect_to home_path
  end
  # /run

end
