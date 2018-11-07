=begin

  Seed qui permet d'avoir Benoit et Alexandra avec :

  BENOIT
    - un module en cours (première étape)
    - des documents déposés sur le qdd

  ALEXANDRA
    Rien pour le moment, seulement l'inscription

  Pour lancer ce seed :

  $ rails db:reset:partage


=end

require "#{Rails.root}/config/secret/data_phil"   # => DATA_PHIL
require "#{Rails.root}/config/secret/data_marion" # => DATA_MARION

# Actif, confirmé, bureau après identification
options_benoit = '21100000'

User.create([
  {name: DATA_PHIL[:pseudo], email: DATA_PHIL[:email],
    prenom: 'Philippe', nom: 'Perret', birthyear: DATA_PHIL[:birthyear],
    statut: 14, sexe: 0, options: '01110000',
    password: DATA_PHIL[:password], password_confirmation: DATA_PHIL[:password]},
  {name: DATA_MARION[:pseudo], email: DATA_MARION[:email],
    prenom: 'Marion', nom: 'Michel', birthyear: DATA_MARION[:birthyear],
    statut: 6, sexe: 1, options: '01210000',
    password: DATA_MARION[:password], password_confirmation: DATA_MARION[:password]},
  {name: 'Benoit Ackerman', email: 'benoit.ackerman@yahoo.fr',
    prenom: 'Benoit', nom: 'Ackerman', birthyear: 1988,
    statut: 1, sexe: 0, options: options_benoit,
    password: 'mot de passe', password_confirmation: 'mot de passe'},
  {name: 'Alexandra', email: 'alexandra.ackerman@yahoo.fr',
    prenom: 'Alexandra', nom: 'Ackerman', birthyear: 1988,
    statut: 0, sexe: 1, options: '01310000',
    password: 'mot de passe', password_confirmation: 'mot de passe'}
  ])
benoit    = User.find_by(email: 'benoit.ackerman@yahoo.fr')
alexandra = User.find_by(email: 'alexandra.ackerman@yahoo.fr')

# Benoit icarien en activité
# (pour le moment, tout se règle ci-dessus)


# Lui faire un module d'apprentissage
paiement_time = Time.now - 4.hours
icmodule = benoit.ic_modules.create(
  abs_module_id: 4,
  state: 1,
  started_at: Time.now - 21.days,
  next_paiement: paiement_time
  ) # Etape 16
# icmodule = IcModule.last

icetape = icmodule.ic_etapes.create(abs_etape_id: 16, started_at: Time.now - 21.days)
# puts "---- Au début, l'étape courante est l'étape ##{icetape.id} (#{icetape.abs_etape.numero} #{icetape.abs_etape.titre})"
icmodule.update_attribute(:current_etape_id, icetape.id)

# Watcher pour le paiement
benoit.action_watchers.create(
  name: 'ic_modules/paiement',
  objet: icmodule,
  triggered_at: paiement_time
  )

# Les documents pour cette première étape. 2 documents
date_comments = Time.now - 3.days
icdocument1 = icetape.ic_documents.create(
  original_name:  "Premier_document_M#{icmodule.id}_E#{icetape.id}.odt",
  commented_at:   date_comments,
  note_auteur:    12,
  original_options:  '10110000',
  comments_options:  '10110000'   # comments existe
)
`mkdir -p "#{Rails.root.join('public','qdd')}"`
src = Rails.root.join('test','fixtures','files','modele_doc.pdf')
# On crée son document sur le QdD
dst = icdocument1.qdd_path(:original)
`cp "#{src}" "#{dst}"` unless File.exist?(dst)
dst = icdocument1.qdd_path(:comments)
`cp "#{src}" "#{dst}"` unless File.exist?(dst)

# Son watcher pour le partage
benoit.action_watchers.create(
  name:   'ic_documents/check_partage',
  objet:  icdocument1
  )

icdocument2 = icetape.ic_documents.create(
  original_name:      "Deuxième document M#{icmodule.id} E#{icetape.id}.odt",
  commented_at:       date_comments,
  note_auteur:        7,
  original_options:  '10110000',
  comments_options:  '00000000'   # comments n'existe pas
)
dst = icdocument2.qdd_path(:original)
`cp "#{src}" "#{dst}"` unless File.exist?(dst)

# Son watcher pour le partage
benoit.action_watchers.create(
  name:   'ic_documents/check_partage',
  objet:  icdocument2
  )

# Les réglages de l'étape avec les documents
opts = icetape.options || '0'*8
opts[1] = '1' # étape "réelle"
icetape.update_attributes(
  status:   6, # => documents déposés mais partage non défini
  options:  opts
)

# On fait passer benoit à l'étape suivante (numéro 50)
icetape = icmodule.ic_etapes.create(abs_etape_id: 17, started_at: Time.now - 5.days)
# puts "---- À la fin, l'étape courante est l'étape ##{icetape.id} (#{icetape.abs_etape.numero} #{icetape.abs_etape.titre})"
icmodule.update_attribute(:current_etape_id, icetape.id)

# Un watcher pour rendre le travail
benoit.action_watchers.create(
  name:   'ic_etapes/sending_work',
  objet:  icetape,
)


# À faire sauf si on est en mode production, mais en même temps, ce seed ne
# devrait servir que pour le développement (et peut-être les tests)
unless Rails.env == 'production'

  benoit.mini_faqs.create({
    abs_etape_id: 17,
    created_at:   Time.now - 4.days,
    question: "Une question de Benoit sur l’étape absolue #17.",
    reponse: "<p>Ici la réponse donnée par Phil, au format HTML avec des <em>italiques</em> et des <b>gras</b> pour voir.</p>",
    state: 1 # Benoit doit dire qu'elle est satisfaite par la queestion
    })
  alexandra.mini_faqs.create({
    abs_etape_id: 17,
    created_at:   Time.now - 12.days,
    question: "Une question par Alexandra sur l'étape absolue #17 aussi",
    reponse: '<p>Réponse complète de Phil</p>',
    state: 2 # Alexandra a dit qu'elle était satisfaite par la queestion
    })
end
