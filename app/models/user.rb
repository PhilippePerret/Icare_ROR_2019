# Modèle d'icarien
class User < ApplicationRecord

  attr_accessor :remember_token

  # @return le mot de passe +pwd+ crypté
  def User.digest(pwd)
    cost = ActiveModel::SecurePassword.min_cost ?
            BCrypt::Engine::MIN_COST :
            BCrypt::Engine::cost
    BCrypt::Password.create(pwd, cost: cost)
  end

  # Pour renvoyer un token sécurisé pour le "remember me" du user
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: {maximum: 50},
    uniqueness: {case_sensitive: false}
  validates :email, presence: true,
    length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  # @return TRUE si le token correspond au digest enregistré
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end


  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  def forget
    update_attribute(:remember_digest, nil)
  end


  def admin?
    false # pour le moment
  end
end
