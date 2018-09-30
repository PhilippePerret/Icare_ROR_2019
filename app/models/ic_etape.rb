class IcEtape < ApplicationRecord

  belongs_to  :ic_module
  belongs_to  :abs_etape

  # has_many :documents


  def user ; ic_module.user end


  # Raccourcis des méthodes d'AbsEtape
  # TODO : trouver un moyen en hériter sans rien faire
  def numero  ; abs_etape.numero  end
  def titre   ; abs_etape.titre   end

end
