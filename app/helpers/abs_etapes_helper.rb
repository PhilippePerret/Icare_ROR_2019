module AbsEtapesHelper

  # Retourne le code ppour le travail propre de l'étape absolue absetape ou
  # false.
  # Noter que ça peut faire référence à une vieille étape que l'icarien
  # revoit
  def travail_propre_for_etape user, absetape, ic_etape = nil
    user != nil || return
    # Si l'ic-étape n'est pas définie, on prend la première qui correspond
    # à l'user, si elle existe.
    ic_etape ||= begin
      uetapes = IcEtapes.where(user_id: user.id, abs_etape_id: absetape.id)
      uetapes.count > 0 || return
      uetapes.first
    end
    ic_etape || return
    # S'il n'y a pas de travail propre, on peut s'en retourner
    !ic_etape.travail_propre.blank? || return
    # On peut retourner le travail propore
    ERB.new(ic_etape.travail_propre).result(ic_etape.bind)
  end

  def liste_liens_for absetape
    absetape.liens.split("\n").collect do |dlien|
      lien_etape(dlien)
    end.join('<br>').html_safe
  end

  def lien_etape(dlien)
    tout, page_id, type, titre = dlien.match(/^([0-9]{1,4})::(livre|collection)(?:::(.*))?$/).to_a
    href =
      if tout
        "http://www.scenariopole.fr/narration/page/#{page_id}"
      else
        href, titre = dlien.split('::')
        href.start_with?('htt') || href.prepend('http://')
        href
      end
    # lien = "<a target=\"_new\" href=\"#{href}\">#{titre || '[titre non défini]'}</a>"
    link_to(titre || '[titre non défini]', href, target: :new)
  end
end
