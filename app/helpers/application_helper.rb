module ApplicationHelper

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
end
