module MiniFaqsHelper

  # Retourne la liste des questions réponses pour l'étape de travail
  # +absetape+
  def questions_reponses_for absetape
    '[Question réponses pour l’étape %i]' % absetape.id
    render absetape.mini_faqs.where('state > ?', 0)
  end
end
