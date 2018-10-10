class IcModule < ApplicationRecord

  belongs_to  :abs_module
  belongs_to  :user
  has_many    :ic_etapes

  # has_many    :documents, through :ic_etapes
  has_many    :paiements
  # has_many    :pauses


  # Retourne true si le module est démarré
  def started? ; state > 0 end
  # Retourne true si le module est terminé
  def ended?   ; state > 2 end

  # Retourne true si c'est un module d'apprentissage courant (donc avec une
  # date de démarrage et pas de date de fin)
  def current? ; state == 1 end
  # Retourne TRUE si c'est un module de type suivi de projet
  def suivi? ; self.abs_module.nombre_jours.nil? end

  def current_etape
    @current_etape ||= IcEtape.find(current_etape_id)
  end
  alias :ic_etape :current_etape

end
