
class User
  def cv_motiv_ok?
    cv_ok && motiv_ok
  end
  attr_accessor :motiv_ok
  attr_accessor :cv_ok
  attr_accessor :modules_optionned # liste des ID de modules optionnés
end

class ActionWatcher < ApplicationRecord

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
    unless current_user.compte_actif? || (session['mail_confirmation_sent'] == '1')
      create_activation_digest
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
      user.set_option(3, 0)
    else
      # Candidature invalide
      # On indique que la candidature est incomplète
      user.set_option(3, 1)
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

    if params[:user][:absmodules].nil?
      user.errors.add(' ', 'Il faut choisir au moins un module d’apprentissage à suivre.')
      @no_error_found = false
    else
      user.modules_optionned = params[:user][:absmodules].keys
    end
    
  end
  # /traite_modules_apprentissage_optionned

  # Traitement des documents de l'inscription. Voir la note au-dessus de la
  # méthode exécute.
  def traite_documents_inscription
    # Soit l'utilisateur a envoyé ses documents de présentation et de motivation
    # soit il faut générer une erreur
    doc_field = params[:user][:doc_presentation]
    current_user.cv_ok =
      traite_document_inscription(doc_field, 'Le document de présentation', 'PRES')

    doc_field = params[:user][:doc_motivation]
    current_user.motiv_ok =
      traite_document_inscription(doc_field, 'La lettre de motivation', 'MOTI')

    doc_field = params[:user][:doc_extraits]
    traite_document_inscription(doc_field, 'Les extraits', 'EXTR', false)

  end
  # /traite_documents_inscription

  # Traitement d'un document de présentation
  def traite_document_inscription doc_field, doc_le_name, doc_type, mandatory = true
    if doc_field.nil?
      if mandatory
        # C'est un document obligatoire. Il faut vérifier s'il existe déjà
        # d'une précédente soumission.
        # Sinon, c'est une erreur
        if user.other_documents.exists?(type: doc_type)
          # C'est bon il a été trouvé
          debug "#{doc_le_name} a été trouvé"
        else
          user.errors.add(doc_le_name, ' est obligatoire.')
          @no_error_found = false
          return false
        end
      end
    else
      # Le document a été fourni, on l'enregistre
      idoc = user.other_documents.create(
        original_name: doc_field.original_filename, type: doc_type)
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
      Ticket.new(
              name: 'activation_compte',
              action: "User.find(%{user_id}).active_compte"
              ).hash_to_create
              )
    user.ticket_token = ticket.token
    # Laisser en bas pour retourner le mail produit
    mail = UserMailer.activation_compte(user, ticket) #=> Class Mail
    mail.deliver_now
    session['mail_confirmation_sent'] = '1'
    return mail # utile ?
  end

end
