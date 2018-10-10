class ActionWatcher < ApplicationRecord


  # Raccourci
  def icmodule  ; objet end
  def absmodule ; icmodule.abs_module end

  # La méthode principale qui exécute l'action-watcher quand on invoque
  # sa méthode `run`
  #
  # Cette méthode est appelée lorsque toutes les vérifications ont été
  # faites sur le paiement du module qui est l'objet de ce watcher.
  #
  # On crée le paiement pour le module
  #
  # S'il s'agit d'un module de suivi, un watcher sera créé pour le prochain
  # paiement.
  #
  # Un mail sera envoyé à l'administration pour prévenir de ce paiement.
  def execute

    # dont_destroy # pour l'implémentation

    # Création du paiement
    icmodule.paiements.create(
      objet:    'Paiement module',
      montant:  absmodule.tarif.to_i,

      )
    if icmodule.suivi?
      trigat = Time.now + 30.days
      user.action_watchers.create(name: 'ic_modules/paiement', objet: objet, triggered_at: trigat)
    end
  end

  def sous_methode_utile

  end
end
