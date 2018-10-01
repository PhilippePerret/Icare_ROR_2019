=begin

  Seed qui permet d'avoir Benoit et Alexandra en inscription

  $ rails db:reset:inscription

  Détails
  =======
    Ils ont déposé leur inscription et confirmé leur mail, mais attendent
    d'être validés.

=end

require "#{Rails.root}/config/secret/data_phil"   # => DATA_PHIL
require "#{Rails.root}/config/secret/data_marion" # => DATA_MARION

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
    statut: 0, sexe: 0, options: '01300000',
    password: 'mot de passe', password_confirmation: 'mot de passe'},
  {name: 'Alexandra', email: 'alexandra.ackerman@yahoo.fr',
    prenom: 'Alexandra', nom: 'Ackerman', birthyear: 1988,
    statut: 0, sexe: 1, options: '01300000',
    password: 'mot de passe', password_confirmation: 'mot de passe'}
  ])
benoit    = User.find_by(email: 'benoit.ackerman@yahoo.fr')
alexandra = User.find_by(email: 'alexandra.ackerman@yahoo.fr')

benoit.action_watchers.create(name: 'user/candidature', objet: benoit, data: '1:2:3')
alexandra.action_watchers.create(name: 'user/candidature', objet: alexandra, data: '5:2:10')
