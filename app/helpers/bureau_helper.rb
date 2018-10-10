module BureauHelper

  # Retourne une liste avec les modules courants de l'icarien +user+, liés
  # pour 1/ voir leur information et surtout 2/ voir leur travail
  def liste_modules_courants_user user
    modules = user.current_modules
    "[LISTE DES MODULES DE L'ICARIEN(NE)]"
  end

end
