module ApplicationHelper

  def full_title page_titre = nil
    if (page_titre.nil? || page_titre.empty?)
      ''
    else
      "#{I18n.t(page_titre)} | "
    end + "Atelier Icare"
  end
end
