require_relative 'html_string'

module ApplicationHelper

  # Parce que parfois, par exemple lorsqu'on appelle la méthode
  # distance_of_time_in_words, le module n'est pas chargé
  include ActionView::Helpers::DateHelper

  # Retourne une date formatée au format français
  #
  # options[:distance] = true => ajoute la distance depuis maintenant
  #
  # Note : on peut aussi utiliser `designation_for(<date>[,<options>])`
  def human_date_for date, options = nil
    options ||= Hash.new
    d = I18n.localize(date, format: (options.delete(:format) || :simple))
    if options[:distance]
      '%s (dans %s)' % [d, distance_of_time_in_words(Time.now, date)]
    else
      d
    end
  end

  # Retourne un menu pour choisir une date depuis +args[:from]+ jusqu'à
  # +args[:to]+ ou pour +args[:for]+ jours (donc items)
  # On peut définir le format avec +args[:format]+
  # L'ID du select sera +args[:id]+
  def human_date_select args
    args.key?(:to) || args.merge!(to: args[:from] + args[:for].days)
    args[:format] ||= :simple
    items = args[:for].times.collect do |itime|
      date = args[:from] + itime.days
      distance = distance_of_time_in_words(Time.now, date)
      ["#{I18n.localize(date, format: args[:format])} (dans #{distance})", date]
    end
    select_tag(args[:id] || 'date_select', options_for_select(items), class: args[:class])
  end

  # Retourne une désignation de n'importe quel objet, même une date
  # Mettre « l'#{icetape.designation} »
  def designation_for(obj, options = nil)
    options ||= Hash.new
    # Cas particulier de la date
    if obj.is_a?(Date) || obj.is_a?(Time)
      return human_date_for(obj, options)
    end
    idobj   = options[:with_ids] || options[:full] ? " (##{obj.id})" : ''
    obj_name =
      case obj
      when AbsEtape   then "étape absolue “#{obj.numero} #{obj.titre}”"
      when IcEtape    then "étape #{obj.abs_etape.numero}"
      when IcModule   then "module “#{obj.abs_module.name}”"
      when User       then obj.name
      when IcDocument then
        if options[:name] || options[:full]
          'document “%{name}”' % {name: obj.original_name}
        else
          'document #%{docid}' % {docid: obj.id}
        end
      else obj.class
      end
    # La désignation simple
    design = "#{obj_name}#{idobj}"

    if options.delete(:with_user)
      design.concat(' de %{pseudo}' % {pseudo: obj.user.name})
    end
    design +=
      case obj
      when AbsEtape
        idmodule = options[:with_ids] || options[:full] ? " (##{obj.abs_module.id})" : ''
        " du module d’apprentissage “#{obj.abs_module.name}”#{idmodule}"
      when IcEtape
        idmodule = options[:with_ids] || options[:full] ? " (##{obj.ic_module.id})" : ''
        " du module “#{obj.ic_module.abs_module.name}”#{idmodule}"
      when IcDocument
        ' de l’%{etape}' % {etape: designation_for(obj.ic_etape, options)}
      else ''
      end

    # S'il faut lier l'objet à sa visualisation
    # En général, ça ressemble à "<objet>/<id>/show"
    if options[:linked]
      design.concat( ' ' + link_to( '[voir]', '/%{objet}s/%{id}' % {objet: obj.class.name.underscore, id: obj.id}, class: 'small', target: :new).html_safe)
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
      'tranquille',
      'un peu surmené',
      'un peu stressé'
    ].shuffle.first
  end
end
