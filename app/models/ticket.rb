class Ticket < ApplicationRecord

  # Un ticket appartient toujours à un unique User/Icarien
  belongs_to :user

  # Pour renseigner les variables qui ont peut-être été placées dans l'action,
  # surtout lorsque c'est une route.
  after_create :rectifie_action

  def initialize with_data
    with_data.key?(:digest) && @digest = with_data[:digest]
    # Définition de la date de péremption si une durée de vie
    # est définie.
    (with_data.key?(:duree) || with_data.key?(:duration)) && begin
      duree = with_data.delete(:duree) || with_data.delete(:duration)
      with_data.merge!(expire_at: Time.current + duree)
    end
    @token = with_data.delete(:token) || SessionsHelper.new_token
    super(with_data)
  end

  def token
    @token
  end
  def calculated_digest
    @calculated_digest ||= BCrypt::Password.create(self.token, cost: 5)
  end

  # Le hash qui doit être envoyé à <user>.tickets.create(<... hash ...>) pour
  # créer un ticket pour l'user
  def hash_to_create
    {name: name, expire_at: expire_at, digest: calculated_digest, action: action, token: token}
  end

  # RETURN true si le ticket est périmé. Pour qu'il soit périmé, il faut
  # qu'une date de péremption ait été définie.
  def out_of_date?
    expire_at && (expire_at < Time.current)
  end

  private

    # Après l'enregistrement (after_save), on corrige certaines valeurs qui
    # ont pu être transmises par variable % dans l'action
    def rectifie_action
      update_attribute(:action, action % {token: token, user_id: user.id, digest: calculated_digest})
    end
end
