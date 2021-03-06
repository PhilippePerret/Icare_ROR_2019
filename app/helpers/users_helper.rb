require_relative 'feminines'

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
  # C'est le statut qui est affiché sur le bureau de l'icarien(ne), pas
  # la valeur correspondant à la propriété `statut` de l'icarien qu'on obtient
  # avec la méthode suivante : human_privileges
  def human_statut(user)
    case
    when user.accepted?   then 'Fraichement reçu%{e}'.sexize(user)
    when user.admin?      then 'Administrat%{rice}'.sexize(user)
    when user.actif?      then 'Icarien%{ne} acti%{ve}'.sexize(user)
    when user.en_pause?   then 'En pause'
    when user.ancien?     then 'Ancien%{ne} icarien%{ne}'.sexize(user)
    when user.postulant?  then 'Postulant%{e}'.sexize(user)
    when user.detruit?    then 'Détruit%{e}'.sexize(user)
    end
  end

  def human_privileges(user)
    case user.statut
    when 0 then 'aucun (simple inscrit%{e})'.sexize(user)
    when 1 then 'minimum (simple icarien%{ne})'.sexize(user)
    else
      if user.statut & 8
        'tout puissant'
      else
        privs = Array.new
        user.statut & 2 > 0 && privs << 'rédact%{eur}'.sexize(user)
        user.statut & 4 > 0 && privs << 'administ%{eur}'.sexize(user)
        privs.join(', ')
      end
    end
  end

end
