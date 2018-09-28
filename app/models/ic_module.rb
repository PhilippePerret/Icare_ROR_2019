class IcModule < ApplicationRecord

  belongs_to  :abs_module
  belongs_to  :user
  # has_one     :ic_etape, as: :current_etape
  has_one     :current_etape, class_name: 'IcEtape', foreign_key: 'ic_etape_id'
  has_many    :ic_etapes

  # has_many    :documents, through :ic_etapes
  # has_many    :paiements
  # has_many :pauses


  # Retourne true si le module est démarré
  def started? ; state > 0 end
  # Retourne true si le module est terminé
  def ended?   ; state > 2 end

  # Retourne true si c'est un module d'apprentissage courant (donc avec une
  # date de démarrage et pas de date de fin)
  def current? ; state == 1 end

end
