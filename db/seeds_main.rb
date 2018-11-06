=begin

  Pour jouer ce fichier :

  $ rails db:reset:main

=end
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
# =========== ATELIER ICARE =============
#
# Pour prendre les données ultimes de l'atelier :
#   * rejoindre l'administration sur AlwaysData
#   * rejoindre myPhpAdmin
#   * exporter les tables séparéments, au format YAML
#   * les enregistrer dans le dossier "old_data" de ce dossier
#   * Lancer un `rails db:reset` qui va effacer les données et
#     les remplacer par les nouvelles.
#
require "#{Rails.root}/config/secret/data_phil"   # => DATA_PHIL
require "#{Rails.root}/config/secret/data_marion" # => DATA_MARION

User.create([
  { id:1, name: DATA_PHIL[:pseudo], email: DATA_PHIL[:email],
    prenom: 'Philippe', nom: 'Perret', birthyear: DATA_PHIL[:birthyear],
    statut: 14, sexe: 0, options: '01100000',
    password: DATA_PHIL[:password], password_confirmation: DATA_PHIL[:password]},
  { id: 2, name: DATA_MARION[:pseudo], email: DATA_MARION[:email],
    prenom: 'Marion', nom: 'Michel', birthyear: DATA_MARION[:birthyear],
    statut: 6, sexe: 1, options: '01200000',
    password: DATA_MARION[:password], password_confirmation: DATA_MARION[:password]},
  {name: 'Benoit Ackerman', email: 'benoit.ackerman@yahoo.fr',
    prenom: 'Benoit', nom: 'Ackerman', birthyear: 1988,
    statut: 2, sexe: 0, options: '11300000',
    password: 'mot de passe', password_confirmation: 'mot de passe'}
  ])

puts "Injection des données de users de base (administrateurs) OK"

unless Rails.env.production?

  # On fait d'autres utilisateurs
  annees = (1970..(Time.now.year-16)).to_a.shuffle.shuffle
  nombre_annees = annees.count
  100.times do |n|
    gender_male = (n % 2 == 0)
    first_name  = Faker::Name.send("#{gender_male ? 'male' : 'female'}_first_name")
    last_name   = Faker::Name.last_name
    name  = "#{first_name} #{last_name}"
    email = Faker::Internet.email
    data_user = {
      name: name, email: email,
      prenom: first_name, nom: last_name,
      birthyear: annees[n % nombre_annees],
      sexe: (gender_male ? 0 : 1),
      statut: 2,
      options: ((n % 4) + 1).to_s + '1' + ((n % 5) + 1).to_s + '00000',
      password: 'mot de passe', password_confirmation: 'mot de passe'
    }
    # puts "\nDATA: #{data_user.inspect}"
    User.create!(data_user)
  end

end

thisfolder = File.expand_path(File.dirname(__FILE__))
OLD_DATA_FOLDER = File.join(thisfolder, 'old_data')

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




unless Rails.env.production?

  # On donne des modules d'apprentissage à benoit
  benoit = User.find(3)
  benoit.ic_modules.create(abs_module_id: 1, state: 1, started_at: Time.now - 2.days)
  icm = IcModule.last
  icetape = icm.ic_etapes.create(abs_etape_id: 1, started_at: Time.now - 2.days)
  icm.update_attribute(:current_etape_id, icetape.id)

  benoit.ic_modules.create(abs_module_id: 4, state: 1, started_at: Time.now - 10.days) # Etape 16
  icm = IcModule.last
  ict = icm.ic_etapes.create(abs_etape_id: 16, started_at: Time.now - 10.days)
  icm.update_attribute(:current_etape_id, ict.id)

end
# /not production

puts "\n\nLE FICHIER PRINCIPAL EST JOUÉ\n\n"
