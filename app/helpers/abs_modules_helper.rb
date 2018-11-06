include ApplicationHelper

module AbsModulesHelper


  def self.liste_modules_a_checker options = nil
    options ||= Hash.new
    prefix_id = options.delete(:prefix_id)

    temp_id   = (prefix_id ? "#{prefix_id}" : '') + '%s'
    temp_name = (prefix_id ? "#{prefix_id}[absmodules][%s]" : 'absmodules[%s]')

    AbsModule.all.collect do |abs_module|
      mod_name = temp_name % abs_module.id.to_s
      htm = <<-HTML
      <div>
        #{MyTagHelpers.check_box_tag(mod_name)}
        #{MyTagHelpers.label_tag(mod_name, abs_module.name)}
        (#{lien_vers(abs_module, 'voir', {target: :new})})
      </div>
      HTML
      htm.html_safe
    end.join('').html_safe

  end

end
