class ActionWatcher < ApplicationRecord

  # Note : ça pourrait être aussi une méthode pour user
  # RETURN l'IcModule créé
  def create_icmodule_for_user(user, module_id)

    # Création du module à l'associant à l'user
    icmodule = user.ic_modules.create(abs_module_id: module_id)

    # Création d'un watcher de démarrage de module
    user.action_watchers.create(name: 'ic_modules/ready', objet: icmodule)

    return icmodule
  end
end
