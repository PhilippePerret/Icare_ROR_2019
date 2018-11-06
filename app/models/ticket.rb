class Ticket < ApplicationRecord

  include Rails.application.routes.url_helpers
  include ApplicationHelper

  # Un ticket appartient toujours à un unique User/Icarien
  belongs_to :user

  # Pour renseigner les variables qui ont peut-être été placées dans l'action,
  # surtout lorsque c'est une route.
  # after_create :rectifie_action

  after_create :exec_after_creation

  def initialize with_data
    # # On peut avoir fourni le ticket à la création de l'association
    # puts "with_data.class: #{with_data.class}"
    # with_data = with_data.hash_to_create if with_data.instance_of?(Ticket)
    # puts "with_data.class: #{with_data.class}"

    with_data.key?(:digest) && @digest = with_data[:digest]
    # Définition de la date de péremption si une durée de vie
    # est définie.
    (with_data.key?(:duree) || with_data.key?(:duration)) && begin
      duree = with_data.delete(:duree) || with_data.delete(:duration)
      with_data.merge!(expire_at: Time.current + duree)
    end
    # TODO Vérifier si c'est toujours nécessaire de procéder comme ça
    @token = with_data.delete(:token) || SessionsHelper.new_token
    super(with_data)
  end

  # ---------------------------------------------------------------------
  # Méthodes d'helper

  def link titre = 'Jouer le ticket'
    ('<a href="%{url}">%{titre}</a>' % {
      url: self.url,
      titre: titre
    }).html_safe
  end

  # Retourne l'URL à jouer pour invoquer le ticket
  #
  # Noter que le token est une donnée volatile qui disparait dès
  # que disparait l'instance. Pour le retrouver, on ne peut que passer par
  # le pseudo-watcher créé à la création du ticket qui possède en data ce
  # token.
  def url
    @url ||= begin
      inprod = Rails.env.production?
      '%{protocol}://%{host}/tickets/%{ticket_id}/%{token}?uid=%{uid}' % {
        protocol:   inprod ? 'https' : 'http',
        host:       inprod ? 'www.atelier-icare.net' : 'localhost:3000',
        ticket_id:  self.id,
        token:      self.token,
        uid:        self.user.id
      }
    end
  end

  # ---------------------------------------------------------------------
  # Data
  def token
    @token || get_token_in_ticket
  end

  def calculated_digest
    @calculated_digest ||= BCrypt::Password.create(self.token, cost: 5)
  end

  # Le hash qui doit être envoyé à <user>.tickets.create(<... hash ...>) pour
  # créer un ticket pour l'user
  def hash_to_create
    {name: name, expire_at: expire_at, digest: calculated_digest, action: action, token: token}
  end

  # ---------------------------------------------------------------------
  # Méthode du watcher
  # Rappel : c'est pour l'essai du watcher associé au ticket, qui contient
  # le token du ticket. C'est un watcher qui ne crée aucune notification
  # avant la date d'expiration
  def action_watcher
    @action_watcher ||= begin
      user.action_watchers.where(model: 'Ticket', model_id: self.id).last
    end
  end
  def get_token_in_ticket
    action_watcher && action_watcher.data
  end
  def create_ticket_action_watcher(token)
    user.action_watchers.create(action: 'user/watcher_ticket', objet: self, data: token, expire_at: expire_at)
  end

  # ---------------------------------------------------------------------
  # Méthode de validation

  # RETURN true si l'user courant est bien l'user du ticket
  def valid_owner?(cuser, uid)
    cuser.admin? || (cuser == User.find(uid))
  end

  # RETURN true si le ticket est périmé. Pour qu'il soit périmé, il faut
  # qu'une date de péremption ait été définie.
  def out_of_date?
    expire_at && (expire_at < Time.current)
  end

  private

    # Opérations à exécuter après la création du ticket :
    #   1. Rectifier les valeurs template dans l'action à jouer
    #   2. Création de l'action-watcher associé au ticket.
    def exec_after_creation
      rectifie_action
      create_ticket_action_watcher(@token)
    end
    
    # Après l'enregistrement (after_save), on corrige certaines valeurs qui
    # ont pu être transmises par variable % dans l'action
    def rectifie_action
      update_attribute(:action, action % {token: token, user_id: user.id, digest: calculated_digest})
    end
end
