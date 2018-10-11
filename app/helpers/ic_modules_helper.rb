module IcModulesHelper

  # Date de démarrage du module +icmodule+ ou indication qu'il doit
  # être démarré
  def human_start_for(icmodule)
    icmodule.started? ? designation_for(icmodule.started_at, distance: true) : I18n.t('module.status.waiting_for_start')
  end
  def numero_et_titre_for(icetape)
    '%i %s' % [icetape.abs_etape.numero, icetape.abs_etape.titre]
  end

  def human_expected_work_at_for(icetape)
    echeance = icetape.expected_end_at || (Time.now + icetape.abs_etape.duree.days)
    human_echeance = designation_for(echeance, distance: true)
    css = echeance < Time.now ? 'danger' : 'success'
    human_echeance = '<span class="text-%s bold">%s</span>' % [css, human_echeance]
    return human_echeance.html_safe
  end
end
