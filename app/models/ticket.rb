class Ticket < ApplicationRecord

  # Un ticket appartient toujours à un unique User/Icarien
  belongs_to :user

  # attr_reader :name, :action
  #
  # def initialize name, action
  #   @name   = name
  #   @action = action
  # end
  #
  # def token
  #   self.token ||= SessionsHelper.new_token
  # end
  # def digest
  #   self.digest ||= BCrypt::Password.create(self.token, cost: 5)
  # end
  #
  # # Le hash qui doit être envoyé à <user>.tickets.create(<... hash ...>) pour
  # # créer un ticket pour l'user
  # def hash_to_create
  #   {name: name, digest: digest, action: action}
  # end

end
