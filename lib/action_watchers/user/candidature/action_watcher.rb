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
    self.success_message = "J'exécute la validation"
  end
  def execute_refus
    self.mailto_user_after_name = 'mail_user_refus.html.haml'
    self.success_message = "J'exécute le refus de la candidature"
  end
end
