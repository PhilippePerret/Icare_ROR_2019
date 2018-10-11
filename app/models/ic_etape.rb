class IcEtape < ApplicationRecord

  belongs_to  :ic_module
  belongs_to  :abs_etape
  has_many    :ic_documents


  def user ; ic_module.user end
  def bind ; binding()      end

  # Raccourcis des méthodes d'AbsEtape
  # TODO : trouver un moyen d'en hériter sans rien faire
  def numero  ; abs_etape.numero  end
  def titre   ; abs_etape.titre   end

  # Retourne true si cette ic-étape est l'étape courante
  # du module
  def current?
    ic_module.current_etape == self
  end

  # Passe l'étape à l'état (status) suivant
  def next_status
    update_attribute(:status, status + 1)
  end

  # Méthode qui peut être appelée par un ticket
  def share_documents which_ones
    # On vérifie que ce soit bien le possesseur de l'étape ou un administrateur
    case which_ones
    when :all
      ic_documents.each { |icd| icd.share_all }
    when :none
      ic_documents.each do |icd|
        icd.dont_share(:original)
        icd.dont_share(:comments) if icd.commented?
      end
    else
      # Une liste d'identifiants.
      # Mais il faut vérifier qu'ils appartiennent bien à l'étape
      which_ones.each do |doc_id|

      end
    end
  end
  # /share_documents

end
