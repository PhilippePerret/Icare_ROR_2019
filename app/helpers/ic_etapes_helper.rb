module IcEtapesHelper

  # Mettre « l'#{icetape.designation} »
  def designation_for(icetape, options = nil)
    options ||= Hash.new
    idetape   = options[:with_ids] || options[:full] ? " (##{icetape.id})" : ''
    idmodule  = options[:with_ids] || options[:full] ? " (##{icetape.ic_module.id})" : ''
    design = "étape #{icetape.abs_etape.numero}#{idetape} du module “#{icetape.ic_module.abs_module.name}”#{idmodule}"
    if options[:capitalize] || options[:cap]
      design.mb_chars.capitalize
    else
      design
    end
  end

end
