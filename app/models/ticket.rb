class Ticket < ApplicationRecord

  # Un ticket appartient toujours à un unique User/Icarien
  belongs_to :user

  def initialize with_data
    with_data.key?(:digest) && @digest = with_data[:digest]
    super(with_data)
  end

  def token
    @token ||= SessionsHelper.new_token
  end
  def calculated_digest
    @calculated_digest ||= BCrypt::Password.create(self.token, cost: 5)
  end

  # Le hash qui doit être envoyé à <user>.tickets.create(<... hash ...>) pour
  # créer un ticket pour l'user
  def hash_to_create
    {name: name, digest: calculated_digest, action: action}
  end

end
