=begin

  Toutes les graines qui doivent être injectées, quel que soit le gel choisi

=end

thisfolder = File.expand_path(File.dirname(__FILE__))
OLD_DATA_FOLDER = File.join(__dir__, 'old_data')

# Chargement des modules absolus
# ==============================
abs_modules_yml = YAML.load_file(File.join(OLD_DATA_FOLDER, 'absmodules.yml'))
AbsModule.create(abs_modules_yml)

# ÉTAPES DE MODULE D'APPRENTISSAGE
# ================================
abs_etapes_yml = YAML.load_file(File.join(OLD_DATA_FOLDER, 'absetapes.yml'))
final_abs_etapes = abs_etapes_yml.collect do |aed|
  aed.delete('travaux')
  aed.merge!('abs_module_id' => aed.delete('module_id'))
  aed
end
# puts 'Nombre d’étapes : %i' % final_abs_etapes.count
AbsEtape.create(final_abs_etapes)

puts "Injection des données absolues des modules OK"
