class Ticket < ApplicationRecord

  include Rails.application.routes.url_helpers
  include ApplicationHelper

  # Un ticket appartient toujours à un unique User/Icarien
  belongs_to :user

  # Choses à faire avant la validation des données. Par exemple, la date
  # d'expiration peut être transmise par la propriété `duree`
  before_validation :exec_before_validation

  # Choses à faire avant la création du ticket
  before_create :exec_before_creation

  # Choses à faire après la création du ticket
  after_create :exec_after_creation

  # les valeurs qui peuvent être passées dans les paramètres envoyés à
  # <user>.tickets.create(<params>)
  # Elles seront traitées ensuite par exec_before_validation pour être
  # transformées ou supprimées
  attr_accessor :duree, :duration


  # ---------------------------------------------------------------------
  # Méthodes d'helper

  # Utiliser la méthode `lien_vers(ticket[, <titre>])`
  def link titre = 'Jouer le ticket', options = nil
    ('<a href="%{url}">%{titre}</a>' % {
      url: self.url(options),
      titre: titre
    }).html_safe
  end

  # Retourne l'URL à jouer pour invoquer le ticket
  #
  # Noter que le token est une donnée volatile qui disparait dès
  # que disparait l'instance. Pour le retrouver, on ne peut que passer par
  # le pseudo-watcher créé à la création du ticket qui possède en data ce
  # token.
  def url(options = nil)
    if options.nil?
      @url ||= begin
        inprod = Rails.env.production?
        '%{protocol}://%{host}%{route}' % {
          protocol:   inprod ? 'https' : 'http',
          host:       inprod ? 'www.atelier-icare.net' : 'localhost:3000',
          route:      route
        }
      end
    else
      # Quand les options ne sont pas nulle, il faut faire une url propre
      inprod = Rails.env.production?
      '%{protocol}://%{host}%{route(options)}' % {
        protocol:   inprod ? 'https' : 'http',
        host:       inprod ? 'www.atelier-icare.net' : 'localhost:3000',
        route:      route
      }
    end
  end

  def route(options = nil)
    options ||= Hash.new
    @base_route ||= "/tickets/#{id}/#{token}"
    options.empty? && (return @base_route)
    r = @base_route + '?'
    options[:secure] && r.concat('uid=%i' % user.id)
    return r
  end

  # ---------------------------------------------------------------------
  # Data

  def token
    @token || get_token_in_ticket
  end

  # def calculated_digest
  #   @calculated_digest ||= BCrypt::Password.create(self.token, cost: 5)
  # end
  #
  # # Le hash qui doit être envoyé à <user>.tickets.create(<... hash ...>) pour
  # # créer un ticket pour l'user
  # def hash_to_create
  #   {name: name, expire_at: expire_at, digest: calculated_digest, action: action, token: token}
  # end

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
    user.action_watchers.create(action: 'user/watcher_ticket', objet: self, data: token, triggered_at: expire_at)
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

    # Ce qu'il faut faire avant la validation
    def exec_before_validation
      if self.duree || self.duration
        self.expire_at = Time.current + (self.duree || self.duration)
      end
    end

    # Ce qu'il y a à faire avant la création
    def exec_before_creation
      @token      = SessionsHelper.new_token # pour le watcher du ticket
      self.digest = BCrypt::Password.create(@token, cost: 5)
    end

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
      update_attribute(:action, action % {token: token, user_id: user.id, digest: digest})
    end
end
