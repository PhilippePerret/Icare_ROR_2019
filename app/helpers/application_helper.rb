require_relative 'html_string'

module ApplicationHelper
  #
  # def default_url_options
  #   {
  #     locale:   I18n.locale,
  #     protocol: (Rails.env == :production ? 'https' : 'http'),
  #     host:     (Rails.env == :production ? 'www.atelier-icare' : 'localhost:3000'),
  #   }
  #
  # end

  # Retourne une date formatée au format français
  def human_date_for date, options = nil
    options ||= Hash.new
    I18n.localize(date, format: (options.delete(:format) || :simple))
  end

  # Retourne une désignation de n'importe quel objet
  # Mettre « l'#{icetape.designation} »
  def designation_for(obj, options = nil)
    options ||= Hash.new
    idobj   = options[:with_ids] || options[:full] ? " (##{obj.id})" : ''
    obj_name =
      case obj
      when IcEtape    then "étape #{obj.abs_etape.numero}"
      when User       then obj.name
      when IcDocument then 'document #%{docid}' % {docid: obj.id}
      else obj.class
      end
    # La désignation simple
    design = "#{obj_name}#{idobj}"

    if options.delete(:with_user)
      design.concat(' de %{pseudo}' % {pseudo: obj.user.name})
    end
    design +=
      case obj
      when IcEtape
        idmodule = options[:with_ids] || options[:full] ? " (##{obj.ic_module.id})" : ''
        " du module “#{obj.ic_module.abs_module.name}”#{idmodule}"
      when IcDocument
        ' pour l’%{etape}' % {etape: designation_for(obj.ic_etape, options)}
      else ''
      end
    if options[:capitalize] || options[:cap]
      design.mb_chars.capitalize
    else
      design
    end
  end
  # /designation_for

  # @return Le titre à utiliser pour la balise HEAD>TITLE de la
  # page
  # @param {String} page_titre
  #                 Soit rien, soit un identifiant de locale, soit un texte
  #                 quelconque qui sera utilisé tel quel.
  def full_title page_titre = nil
    if (page_titre.nil? || page_titre.empty?)
      ''
    elsif I18n.exists?(page_titre)
      "#{I18n.t(page_titre)} | "
    else
      "#{page_titre} | "
    end + "Atelier Icare"
  end

  # Pour définir en même temps la balise title et le titre de la page
  def set_title(titre_page, title = nil)
    title ||= titre_page
    provide(:title, title)
    provide(:titre_page, titre_page)
  end


  # @return TRUE si on est sur le formulaire d'inscription
  def signup_route?
    (params[:controller] == 'users' &&
    (params[:action] == 'new') || params[:action] == 'create')
  end

  # Il faut mettre les locales dans locale/fr/views.yml, dans la partie
  # 'myLabel'. +locale+ ci-dessous ne doit pas contenir myLabel
  def myLabel(locale, options = nil)
    options ||= Hash.new
    lab = I18n.t("myLabel.#{locale}")
    options[:suffix] && lab.concat(options[:suffix])
    options[:prefix] && lab.prepend(options[:prefix])
    (options[:cap] || options[:capitalize]) && lab = lab.mb_chars.capitalize.to_s
    content_tag(:label, lab, class: options[:class])
  end

  def site
    @site ||= begin
      {
        name:         'Atelier Icare',
        locale_url:   'localhost:3000',
        distant_url:  'www.atelier-icare.net',
        facebook:     'Atelier-Icare-711999635586581/',
        twitter:      nil
      }
    end
  end

  # Retourne un état pour Ernest, dans les mails, qui se retrouvera dans la
  # signature :
  #   Ernest, le bot <etat bot> de l'atelier icare.
  def etat_bot
    [
      'bien tranquille',
      'complètement surmené',
      'dévoué',
      'en chef',
      'surmené',
      'tout à vos soins',
      'un peu surmené',
      'un peu stressé'
    ].shuffle.first
  end
end
