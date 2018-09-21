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

end
