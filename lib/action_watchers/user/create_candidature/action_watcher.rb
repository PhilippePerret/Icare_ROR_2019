class ActionWatcher < ApplicationRecord

  def doc_presentation
    @doc_presentation ||= params_candidature[:doc_presentation]
  end
  def doc_motivation
    @doc_motivation ||= params_candidature[:doc_motivation]
  end
  def doc_extraits
    @doc_extraits ||= params_candidature[:doc_extraits]
  end
  def params_candidature
    @params_candidature ||= params[:candidature] || Hash.new
  end

  # La méthode principale qui exécute l'action-watcher quand on invoque
  # sa méthode `run`
  #
  # Création complète de la candidature après vérification de la validité
  # du formulaire.
  #
  # Noter que user a été instancié mais pas encore sauvé.
  # Il sera créé si les données user sont valides et que des documents ont été
  # fournis ou que des modules ont été choisis, afin de ne pas multiplier les
  # redéfinitions du formulaire.
  #
  # TRAITEMENT DES DOCUMENTS
  # ------------------------
  #   Pour ne pas avoir à redonner les documents en cas d'erreur, ils sont
  #   toujours enregistrés dès que l'on soumet la candidature, s'ils sont
  #   donnés. Donc, la seconde fois, si les documents ne sont pas donnés, on
  #   vérifie qu'ils n'existent pas déjà.
  #
  def execute
    # dont_destroy    # Pour ne pas détruire le watcher, pendant conception
    # dont_send_mails # pour ne pas envoyer les mails, idem

    # On envoie un mail au candidat pour qu'il confirme son adresse email. Mais
    # seulement si ça n'a pas encore été fait.
    unless user.mail_activation_sent?
      create_activation_digest
    end

    # Si on passe ici, c'est que l'user a pu être créé dans la base de données
    # On lui crée un watcher de candidature si nécessaire :
    # Note : il sera indiqué, pour l'user et pour l'administrateur, que cette
    # candidature est incomplète.
    if user.watcher_candidature.nil?
      # On crée un watcher pour valider l'inscription
      user.action_watchers.create(objet: user, action: 'user/candidature', data: nil)
    end

    # On peut enregistrer l'user, ou on raise
    # NON Maintenant, ça doit obligatoirement être fait dans le contrôleur,
    # pour pouvoir créer le watcher d'inscription
    # user.save || destroy_and_raise

    # Soit la candidature est valide, c'est-à-dire que :
    #   1. les documents obligatoires sont fournis
    #   2. des modules ont été choisis
    # soit on re-propose le formulaire au candidat
    # Dans les deux cas, on (re)définit l'option 3 (4e bit) qui permet
    # de savoir si la candidature est complète ou non. Grâce à ce bit, on sait,
    # à la réidentification de l'user, s'il faut le reconduire vers le
    # formulaire d'inscription.
    if candidature_valide?
      # On indique que la candidature est complète
      user.set_option(3, 1)
    else
      # Candidature invalide
      # --------------------
      # On indique que la candidature est incomplète
      user.set_option(3, 0)
      destroy_and_raise
    end

  end
  # /execute


  # Retourne true si le formulaire d'inscription a été correctement rempli
  # au niveau des documents envoyés et des modules choisis.
  def candidature_valide?

    @no_error_found = true

    traite_documents_inscription

    traite_modules_apprentissage_optionned

    return @no_error_found
  end
  # /candidature_valide?


  def traite_modules_apprentissage_optionned

    # On doit traiter seulement si les modules d'apprentissage n'ont pas
    # encore été choisis.
    if !user.modules_optionned
      if params[:candidature][:absmodules].nil?
        user.errors.add(' ', 'Il faut choisir au moins un module d’apprentissage à suivre.')
        @no_error_found = false
      else
        user.modules_optionned = params[:candidature][:absmodules].keys.join(':')
        # Il faut les ajouter au watcher de candidature
        user.watcher_candidature.update_attribute(:data, user.modules_optionned)
      end
    end
    
  end
  # /traite_modules_apprentissage_optionned

  # Traitement des documents de l'inscription. Voir la note au-dessus de la
  # méthode exécute.
  def traite_documents_inscription
    # Soit l'utilisateur a envoyé ses documents de présentation et de motivation
    # soit il faut générer une erreur
    traite_document_inscription(doc_presentation, 'Le document de présentation', 'PRES')
    traite_document_inscription(doc_motivation,   'La lettre de motivation', 'MOTI')
    traite_document_inscription(doc_extraits,     'Les extraits', 'EXTR', false)

  end
  # /traite_documents_inscription

  # Traitement d'un document de présentation
  def traite_document_inscription doc_field, doc_le_name, doc_type, mandatory = true
    if doc_field.nil?
      if mandatory
        # C'est un document obligatoire. Il faut vérifier s'il existe déjà
        # d'une précédente soumission.
        # Sinon, c'est une erreur
        unless user.other_documents.exists?(dtype: doc_type)
          user.errors.add(doc_le_name, ' est obligatoire.')
          @no_error_found = false
          return false
        end
      end
    else
      # Le document a été fourni, on l'enregistre
      idoc = user.other_documents.create(
        original_name: doc_field.original_filename,
        dtype: doc_type
        )
      idoc.original.attach(doc_field)
    end
    return true
  end
  #/traite_document_inscription


  # Envoie un mail pour que l'user puisse confirmer son adresse email et
  # donc activer son compte vraiment.
  # RETURN l'instance mail envoyée, utile pour les tests
  def create_activation_digest
    ticket = user.tickets.create(
      name:   I18n.t('tickets.titres.activer_compte'),
      action: 'u=User.find(%i);u.active_compte;flash[:info]="%s";u.option(3) == 0 && redirection = login_user(u)' % [user.id, I18n.t('users.success.compte_actived', {name: user.name})],
      duree:  7.days
    )
    # Laisser en bas pour retourner le mail produit
    mail = UserMailer.activation_compte(user, ticket) #=> Class Mail
    mail.deliver_now
    # On indique que le mail d'activation a été envoyé
    user.set_option(4,1)
    return mail # utile ?
  end

end
