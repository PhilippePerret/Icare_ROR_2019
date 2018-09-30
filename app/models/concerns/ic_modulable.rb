=begin
  Module pour étendre la classe de l'user avec tout ce qui concerne
  ses modules d'apprentissage.
=end
module IcModulable
  extend ActiveSupport::Concern

  # Retourne la liste des modules de l'user en cours.
  # Le plus souvent il n'y en a qu'un seul.
  def current_modules
    self.ic_modules.where(state: 1)
  end

end
