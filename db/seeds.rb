# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require './config/secret/data_phil'   # => DATA_PHIL
require './config/secret/data_marion' # => DATA_MARION

User.create([
  {name: DATA_PHIL[:pseudo], email: DATA_PHIL[:email],
    prenom: 'Philippe', nom: 'Perret', birthyear: DATA_PHIL[:birthyear],
    statut: 14, sexe: 0, options: '01100000',
    password: DATA_PHIL[:password], password_confirmation: DATA_PHIL[:password]},
  {name: DATA_MARION[:pseudo], email: DATA_MARION[:email],
    prenom: 'Marion', nom: 'Michel', birthyear: DATA_MARION[:birthyear],
    statut: 6, sexe: 1, options: '01200000',
    password: DATA_MARION[:password], password_confirmation: DATA_MARION[:password]},
  {name: 'Benoit Ackerman', email: 'benoit.ackerman@yahoo.fr',
    prenom: 'Benoit', nom: 'Ackerman', birthyear: 1988,
    statut: 2, sexe: 0, options: '01300000',
    password: 'mot de passe', password_confirmation: 'mot de passe'}
  ])

unless Rails.env == 'production'

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
