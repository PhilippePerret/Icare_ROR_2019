class ActionWatcher < ApplicationRecord

  def icetape
    @icetape ||= objet
  end
  def icdocuments
    @icdocuments ||= icetape.ic_documents
  end

  # Méthode pour indiquer que les commentaires ont été chargés. En fait,
  # c'est un bouton qui permet de le faire.
  #
  def execute
    # require 'rubygems'
    require 'zip'

    # On prépare les fichiers temporaires qui seront zippés
    arr_comments = preparer_les_commentaires_temporaires
    # On crée le zip contenant les fichiers et on le place dans le
    # dossier /public, avec une date d'expiration si possible.
    zipper_les_commentaires(arr_comments)

    # Faire passer l'étape à l'état suivant
    icetape.next_status

    # TODO Watcher suivant : celui pour déposer les documents sur le Quai des
    # docs.
    wachers_pour_qdd

    # TODO Penser à mettre l'ID de l'user dans le nom du zip pour qu'il soit
    # le seul à pouvoir le charger (vérification dans le contrôleur). Pour le
    # moment, ça ne fonctionne pas comme ça.

    # ATTENTION : cette méthode est propre à l'instance action-watcher, elle
    # permet de rediriger le run du contrôleur.
    redirect_to("/#{zipfile_name}")

  end
  # /execute

  # Retourne une liste pour le fichier ZIP, où chaque élément est un Array
  # contenant [filename, filepath]
  def preparer_les_commentaires_temporaires
    icdocuments.collect do |icdocument|
      icdocument.comments.attached? || next
      # On crée le fichier dans le dossier temporaire
      filepath = icdocument.save_comments_in_tmpfile
      # On indique que ce document a été chargé
      icdocument.set_option(:comments, 2, 1)
      # On retourne les valeurs qui serviront pour le zip
      [File.basename(filepath), filepath]
    end
  end
  # /preparer_les_commentaires_temporaires


  def zipper_les_commentaires(arr_comments)
    File.unlink(zipfile_path) if File.exist?(zipfile_path) # ça pourrait être dans la config, aussi
    Zip::File.open(zipfile_path, Zip::File::CREATE) do |zipfile|
      arr_comments.each do |filename, filepath|
        zipfile.add(filename, filepath)
      end
    end
    return zipfile_name
  end
  # /zipper_les_commentaires

  def wachers_pour_qdd
    icdocuments.each do |icdocument|
      user.action_watchers.create(name: 'ic_documents/depot_qdd', objet: icdocument)
    end
  end
  # /wachers_pour_qdd

  private

    def zipfile_name
      @zipfile_name ||= begin
        'Commentaires-M%{mod_id}-E%{etp_id}-U%{user_id}.zip' % {
          mod_id:   icetape.ic_module.id,
          etp_id:   icetape.id,
          user_id:  user.id
        }
      end
    end
    # /zipfile_name
    def zipfile_path
      @zipfile_path ||= Rails.root.join('public',zipfile_name)
    end

end
