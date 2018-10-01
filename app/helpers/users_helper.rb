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
      <img src="#{gravatar_url(user, size: avi_size)}" class="gravatar" alt="" style="width:#{img_size}px;" />
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
      class:  'gravatar',
      style:  'float:inherit'
    )
  end
  def gravatar_url(user, size: 80)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    # "https://www.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end

  # Statut humain de l'icarien (actif, en pause, etc.)
  def human_statut(user)
    case
    when user.admin?      then 'Administra%{trice}'.sexize(user)
    when user.actif?      then 'Icarien%{ne} acti%{ve}'.sexize(user)
    when user.en_pause?   then 'En pause'
    when user.ancien?     then 'Ancien%{ne} icarien%{ne}'.sexize(user)
    when user.postulant?  then 'Postulant%{e}'.sexize(user)
    when user.detruit?    then 'Détruit%{e}'.sexize(user)
    end
  end

end
class String
  def sexize(user = nil)
    user ||= current_user
    self % hash_feminin_masculin(user)
  end
  def hash_feminin_masculin(user)
    is_f = user.femme?
    {
      e:      is_f ? 'e'      : '',
      ne:     is_f ? 'ne'     : '',
      trice:  is_f ? 'trice'  : 'teur',
      ve:     is_f ? 've'     : 'f',      # actif/active
    }
  end
end
