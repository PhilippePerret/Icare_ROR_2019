
class ActionWatcher < ApplicationRecord

  # Validation de la candidature ou refus.
  #
  # L'un et l'autre se distinguent de cette manière :
  #   * en cas de validation, params[:validation_candidature][:module_id] est défini et pas
  #     params['refus_candidature'][:motif]
  #   * en cas de validation, c'est le contraire
  def execute
    pour_validation = !!params[:module_id] && !params[:motif_refus]
    pour_refus      = !!params[:motif_refus] && !params[:module_id]
    pour_validation == !pour_refus || raise(I18n.t('users.candidature.errors.bad_validation_candidature'))
    self.send("execute_#{pour_refus ? 'refus' : 'validation'}")
  rescue Exception => e
    self.danger_message = e.message
  end

  def execute_validation
    require_relative 'creation_icmodule'
    # On marque qu'il est accepté
    user.set_accepted
    # On lui crée son module d'apprentissage
    icmodule = create_icmodule_for_user(user, params[:module_id].first.to_i)
    # Note : un email lui sera automatiquement envoyé
    self.success_message = I18n.t('users.candidature.confirmed', {pseudo: user.name, id: icmodule.id})
  end
  def execute_refus
    # On marque que l'user est détruit
    user.destroy
    # On doit modifier le mail envoyé
    self.mailto_user_after_name = 'mailto_user_refus.html.erb'
    self.success_message = "Le refus de la candidature de la candidature de #{user.name} a été exécutée."
  end
end
