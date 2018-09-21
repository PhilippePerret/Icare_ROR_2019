module UsersHelper

  # Retourne le code pour l'avatar de l'user, ou un avatar
  # par défaut
  def gravatar_for user, size: 80
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    image_tag(
      "https://secure.gravatar.com/avatar/##{gravatar_id}?size=#{size}",
      alt:    'Photo',
      class:  'gravatar'
    )
  end
end
