=begin

  Module de démarrage du module d'apprentissage de l'icarien courant.

=end
class User < ApplicationRecord
  # RETURN True si l'user est un nouvel icarien
  # (on le sait s'il n'a qu'un seul module d'apprentissage, celui qu'il démarre)
  def new_icarien?
    @is_new_icarien ||= statut == 0
  end
end

class ActionWatcher < ApplicationRecord

  # = main =
  #
  def start_icmodule

    icmodule    = objet       # pour la clarté
    abs_module  = icmodule.abs_module # pour simplifier

    # Récupérer l'indice de la première étape du module d'apprentissage
    abs_etape = AbsEtape.where(abs_module_id: abs_module.id, numero: 1).first ||
                  raise('Impossible de trouver la première étape du module')
    # puts "abs_etape : #{abs_etape.inspect}"

    # Crée une ic-etape au module
    # Note : la date de démarrage de l'étape (started_at) ne sera affectée
    # que lorsque l'user visitera son bureau. Noter que ici, pour la première
    # étape, ça correspond à tout de suite, puisque l'user revient tout de
    # suite dans son bureau.
    icetape = icmodule.ic_etapes.create(abs_etape_id: abs_etape.id, status: 1)
    # puts "icetape: #{icetape.inspect}"

    # Créer un watcher de paiement
    paiement_time = user.new_icarien? ? (Time.now + 21.days) : Time.now
    aw_paiement = create_watcher_paiement(paiement_time)
    # Créer un watcher pour rendre son travail
    aw_travail  = create_watcher_to_send_work(icetape)

    # Enregistrer les données du module
    # Note : le faire à la fin, quand on est sûr que tout a fonctionné
    icmodule.update_columns({
      state:            1,
      current_etape_id: icetape.id,
      next_paiement:    paiement_time,
      started_at:       Time.now,
      updated_at:       Time.now
      })

    # Changer le statut de l'icarien, qui devient actif
    user.set_actif
    # Attention, on ne doit plus utiliser la méthode new_icarien? après ce
    # changement de statut.
    user.statut = 1 if user.new_icarien?
    user.save

    return true # pour confirmer le succès
  rescue Exception => e
    puts "---- ERREUR: #{e.message}"
    puts e.backtrace[0..5].join("\n")
    return false
  end
  # /start_icmodule

  def create_watcher_paiement(triggered_at)
    user.action_watchers.create(name: 'ic_modules/paiement', objet: objet, triggered_at: triggered_at)
  end

  def create_watcher_to_send_work(icetape)
    user.action_watchers.create(name: 'ic_etapes/sending_work', objet: icetape)
  end
end
