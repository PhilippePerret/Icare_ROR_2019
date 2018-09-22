module UsersHelper

  def user_pseudo user, options = nil
    options ||= Hash.new
    img_size, avi_size =
      case options[:size]
      when :small   then [20, 20]
      when :medium  then [40, 40]
      when :large   then [60, 60]
      when :biggest then [80, 80]
      else [40, 40]
      end
    <<-HTML
    <span class="" style="">
      <img src="#{gravatar_url(user, size: avi_size)}" alt="" style="width:#{img_size}px;" />
      #{user.name.capitalize}
    </span>
    HTML
  end

  # Retourne le code pour l'avatar de l'user, ou un avatar
  # par défaut
  def gravatar_for user, size: 80
    image_tag(
      gravatar_url(user, size: size),
      alt:    'Photo',
      class:  'gravatar'
    )
  end
  def gravatar_url(user, size: 80)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    # "https://www.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end
end
