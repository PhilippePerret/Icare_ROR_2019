# Modèle d'icarien
class User < ApplicationRecord

  has_secure_password

  attr_accessor :remember_token
  attr_accessor :ticket_token # pour les tickets, à commencer par l'activation

  has_many :tickets

  # RETURN le mot de passe +pwd+ crypté
  def User.digest(pwd)
    cost = ActiveModel::SecurePassword.min_cost ?
            BCrypt::Engine::MIN_COST :
            BCrypt::Engine::cost
    BCrypt::Password.create(pwd, cost: cost)
  end


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  before_save {email.downcase!}

  validates :name,  presence: true, length: {maximum: 50},
    uniqueness: {case_sensitive: false}
  validates :email, presence: true,
    length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  # Année de naissance
  validates :birthyear, presence: true, format: {with: /\A(19|20)[0-9][0-9]\z/}, numericality: true
  validates :sexe,      presence: true, inclusion: {in: (0..2)}, numericality: true

  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  # RETURN TRUE si le token correspond au digest enregistré
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end


  def remember
    self.remember_token = SessionsHelper.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  def forget
    update_attribute(:remember_digest, nil)
  end


  def admin?
    self.statut & 4 > 0
  end
  def super_admin?
    self.statut & 8 > 0
  end

  def femme?
    @is_femme ||= sexe == 1
  end

  # Pour ajouter un 'e' si c'est une femme
  def f_e
    femme? ? 'e' : ''
  end

  def set_option offset, value
    self.options[offset] = value.to_s
    self.update_attribute(:options, options)
  end

  def destroy
    set_option(0, 9)
  end

  # Envoie un mail pour que l'user puisse confirmer son adresse email et
  # donc activer son compte vraiment.
  # RETURN l'instance mail envoyée, utile pour les tests
  def create_activation_digest
    @ticket = Ticket.new(
              name: 'activation_compte',
              action: "User.find(#{self.id}).active_compte"
              )
    self.tickets.create(@ticket.hash_to_create)
    self.ticket_token = @ticket.token
    return UserMailer.activation_compte(self)
  end

  # Méthode d'activation du compte
  def active_compte
    set_option(1, 1)
  end

  # RETURN true si le compte est actif (email confirmé)
  def compte_actif?
    self.options[1] == '1'
  end

end
