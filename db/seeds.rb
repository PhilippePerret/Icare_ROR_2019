# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create([
  {name: 'Phil', email: 'phil@atelier-icare.net',
    prenom: 'Philippe', nom: 'Perret', birthyear: 1964,
    statut: 14, sexe: 0,
    password: 'mot de passe', password_confirmation: 'mot de passe'},
  {name: 'Marion', email: 'marion.michel31@free.fr',
    prenom: 'Marion', nom: 'Michel', birthyear: 1992,
    statut: 6, sexe: 1,
    password: 'mot de passe', password_confirmation: 'mot de passe'},
  {name: 'Benoit Ackerman', email: 'benoit.ackerman@yahoo.fr',
    prenom: 'Benoit', nom: 'Ackerman', birthyear: 1988,
    statut: 2, sexe: 0,
    password: 'mot de passe', password_confirmation: 'mot de passe'}
  ])

annees = (1970..Time.now.year).to_a.shuffle.shuffle
100.times do |n|
  gender_male = (n % 2 == 0)
  first_name  = Faker::Name.send("#{gender_male ? 'male' : 'female'}_first_name")
  last_name   = Faker::Name.last_name
  name  = "#{first_name} #{last_name}"
  email = Faker::Internet.email
  User.create!(
    name: name, email: email,
    prenom: first_name, nom: last_name,
    birthyear: annees[n],
    sexe: (gender_male ? 0 : 1),
    statut: 2,
    password: 'mot de passe', password_confirmation: 'mot de passe'
  )
end
