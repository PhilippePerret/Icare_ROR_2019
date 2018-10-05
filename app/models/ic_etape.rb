class IcEtape < ApplicationRecord

  belongs_to  :ic_module
  belongs_to  :abs_etape
  has_many    :ic_documents


  def user ; ic_module.user end


  # Raccourcis des méthodes d'AbsEtape
  # TODO : trouver un moyen en hériter sans rien faire
  def numero  ; abs_etape.numero  end
  def titre   ; abs_etape.titre   end

  # Passe l'étape à l'état (status) suivant
  def next_status
    update_attribute(:status, status + 1)
  end

  # Méthode qui peut être appelée par un ticket
  def partage_all_documents
    # On vérifie que ce soit bien le possesseur de l'étape ou un administrateur
    # TODO Développer la méthode pour partager les documents
  end

end
