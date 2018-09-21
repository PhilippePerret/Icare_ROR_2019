# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create([
  {id: 1, name: 'Philippe Perret', email: 'phil@atelier-icare.net',
    password: 'motdepasse', password_confirmation: 'motdepasse'},
  {id: 2, name: 'Marion Michel', email: 'marion.michel31@free.fr',
    password: 'motdepasse', password_confirmation: 'motdepasse'}
  ])
