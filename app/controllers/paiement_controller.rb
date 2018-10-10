class PaiementController < ApplicationController

  # Avant toutes les opérations, l'user doit être loggué
  before_action :logged_in_user

  # Appelé lorsque l'on fait juste '/paiement'
  def proc
  end

  # Appelé après un paiement effectué avec succès
  def ok
    # On fait tout un tas de vérification pour voir si c'est bon
    begin
      uid, mid, wid, montant, token = params[:sku].split('-')
      uid.to_i == current_user.id || raise(I18n.t('paiements.errors.not_paiement_author'))
      icmodule = IcModule.find(mid)
      icmodule.user == current_user || raise(I18n.t('paiements.errors.not_module_author'))
      BCrypt::Password.new(session['paiement_digest']).is_password?(token) || raise(I18n.t('paiements.errors.paiement_not_authentified'))
      montant.to_i == icmodule.abs_module.tarif.to_i || raise(I18n.t('paiements.errors.tarif_doesnt_match'))
      awatcher = ActionWatcher.find(wid)
      awatcher.action == 'ic_modules/paiement' || raise(I18n.t('paiements.errors.action_watcher.bad_action'))
      awatcher.user == current_user || raise(I18n.t('paiements.errors.action_watcher.bad_owner'))
      awatcher.objet == icmodule    || raise(I18n.t('paiements.errors.action_watcher.bad_objet'))
    rescue ActiveRecord::RecordNotFound => e
      flash[:danger] = e.message
      redirect_back(fallback_location: root_path)
    rescue Exception => e
      flash[:danger] = "Désolé, je ne peux pas accepter ce paiement : #{e.message}"
      redirect_back(fallback_location: root_path)
    end

    # Si on arrive ici, c'est que tout est OK, on peut procéder à l'enregistrement
    # du paiement en jouant le watcher
    awatcher.run_for(current_user, params)
    # Les messages à afficher dans la page de succès
    awatcher.success_message.blank?   || flash[:success] = aw.success_message
    awatcher.danger_message.blank?    || flash[:danger]  = aw.danger_message
    @icmodule = icmodule

  end

  # Appelé après une annulation de paiement
  def cancel
    flash.now[:danger] = I18n.t('paiements.errors.cancelled')
    render :proc
  end
end
