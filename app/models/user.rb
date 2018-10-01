# Modèle d'icarien
class User < ApplicationRecord

  include IcModulable

  has_secure_password

  attr_accessor :remember_token
  attr_accessor :ticket_token # pour les tickets, à commencer par l'activation

  has_many :ic_modules
  has_many :ic_etapes, through: :ic_modules
  has_many :documents, through: :ic_etapes

  has_many :action_watchers
  has_many :tickets

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
    update_attribute(:remember_digest, SessionsHelper.digest(remember_token))
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

  def option(offset)
    self.options[offset].to_i
  end
  def postulant?  ; option(0) == 0  end
  def actif?      ; option(0) == 1  end
  def en_pause?   ; option(0) == 2  end
  def ancien?     ; option(0) == 3  end
  def detruit?    ; option(0) == 9  end
  # Méthodes de transformation
  def set_actif     ; set_option(0,1)  end
  def set_en_pause  ; set_option(0,2)  end
  def set_ancien    ; set_option(0,3)  end
  def femme?    ; @is_femme ||= sexe == 1 end

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
    ticket = self.tickets.create(
      Ticket.new(
              name: 'activation_compte',
              action: "User.find(%{user_id}).active_compte"
              ).hash_to_create
              )
    self.ticket_token = ticket.token
    # Laisser en bas pour retourner le mail produit
    mail = UserMailer.activation_compte(self, ticket) #=> Class Mail
    mail.deliver_now
    return mail
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
