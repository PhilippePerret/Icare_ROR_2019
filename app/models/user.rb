# Modèle d'icarien
class User < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: {maximum: 50},
    uniqueness: {case_sensitive: false}
  validates :email, presence: true,
    length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}


  # Retourne la route à suivre après l'identification de l'user
  # Pour le moment, on envoie vers le bureau (bureau_path) qui conduit
  # à une page virtuelle
  def redirection_after_login
    opt = 1
    case opt
    when 1 then '/bureau'
    when 2 then '/profil'
    when 3 then '/'
    when 4 then '/last_activites'
      # TODO Mettre les autres path possible
    end
  end
end
