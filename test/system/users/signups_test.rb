require "application_system_test_case"

class UsersSignupsTest < ApplicationSystemTestCase
  def data_user
    @data_user ||= begin
      suffix = Time.now.to_i.to_s[-5..-1]
      {
        name: 'NewOne%s' % suffix,
        mail: 'newone%s@chez.lui' % suffix,
        password: 'motdepasse',
        sexe: '1', hsexe: 'femme'
      }
    end
  end
  def bio_path
    @bio_path ||= File.expand_path('./test/fixtures/files/presentation_candidat.pdf')
  end
  def lettre_motivation_path
    @lettre_motivation_path ||= File.expand_path('./test/fixtures/files/lettre_motivation.pdf')
  end
  def extraits_path
    @extraits_path ||= File.expand_path('./test/fixtures/files/extraits.pdf')
  end


  test 'Un visiteur peut rejoindre le formulaire d’inscription' do
    # On rejoint le site et on clique sur le bouton "Poser sa candidature"
    visit root_path
    assert_link('Poser sa candidature')
    click_link 'Poser sa candidature'
    assert_selector('h2', text: 'Poser sa candidature')
  end


  # test 'Pour voir si l extension ActionMailer fonctionne' do
  #   assert ActionMailer::Base.exists?(subject: 'Mon sujet'), ActionMailer::Base.search_main_error
  # end

  test 'Un visiteur peut s’inscrire avec des données correctes' do

    # ---- AVANT DE COMMENCER ----
    ActionMailer::Base.deliveries.clear
    nombre_users_init = User.count

    # puts "Nombre d'users au début : #{nombre_users_init}"

    # ------ ON COMMENCE LE TEST ---------

    # On rejoint le site et on clique sur le bouton "Poser sa candidature"
    visit root_path
    assert_link('Poser sa candidature')
    click_link 'Poser sa candidature'

    # Dans le formulaire, on remplit les champs d'identité
    assert_selector('h2', text: 'Poser sa candidature')
    within('form#new_user') do

      fill_in 'user_name',  with: data_user[:name]
      fill_in 'user_email', with: data_user[:mail]
      fill_in 'user_password',  with: data_user[:password]
      fill_in 'user_password_confirmation',  with: data_user[:password]
      select( data_user[:hsexe], from: 'user[sexe]')

      # Les documents de présentation
      attach_file 'candidature_doc_presentation', bio_path
      attach_file 'candidature_doc_motivation', lettre_motivation_path

      # Les modules optionnés
      check 'candidature_absmodules_2'
      check 'candidature_absmodules_4'
      check 'candidature_absmodules_6'

      click_button 'Poser ma candidature'
    end
    # /fin remplissage formulaire

    # On doit se retrouver sur une page confirmant l'inscription
    assert_selector('h2', text:'Candidature enregistrée')
    sleep 2
    take_screenshot

    # À partir de là, on peut vérifier si tout est OK
    # ------------------------------------------------

    # Un nouveau user doit avoir été créé
    assert_equal nombre_users_init + 1, User.count

    # On prend le dernier user créé
    last_user = User.last
    # puts "---- Le nouvel user a l'ID ##{last_user.id}"

    # On prend l'user courant dans l'application
    # current_user = assigns(:current_user)
    # puts "---- L'user courant du programme à l'ID ##{current_user.id}"

    # TODO L'user doit être loggué

    # Les options du nouveau candidat doivent être bonnes
    options = last_user.options
    # L'user doit être à valider
    assert_equal '0', options[0]
    # Le mail ne doit pas être confirmé
    assert_equal '0', options[1]
    # Un bit doit indiquer que l'inscription est complète
    assert_equal('1', options[3], 'le bit d’inscription complète devrait être à 1')
    # Un bit doit indiquer que le mail d'activation du compte est envoyé
    assert_equal '1', options[4]


    # Un watcher pour valider l'inscription doit avoir été créé
    aw = ActionWatcher.where(user_id: last_user.id, action_watcher_path: 'user/candidature').last
    assert_not_nil(aw, 'Le watcher de validation devrait être créé')
    # Les données du watcher sont correctes
    assert_equal( 'User', aw.model, 'Le model du Watcher devrait être « User »')
    assert_equal(last_user.id, aw.model_id, 'Le model_id du watcher devrait être l’ID du user créé (#%i)' % last_user.id)
    # Les données doivent contenir les modules optionnés
    assert_equal('2:4:6', aw.data, 'Les data du watcher de validation devraient être la liste des modules optionnés.')

    # Trois mails ont dû être envoyé
    assert_equal 3, ActionMailer::Base.deliveries.count, 'Trois mails ont été envoyés au cours du processus d’inscription'


    # Le mail pour activer le compte doit avoir été envoyé
    assert ActionMailer::Base.exists?({
      subject: I18n.t('user_mailer.activation_compte.subject'),
      to:       last_user.email,
      from:     'admin@atelier-icare.net'
      },
      {lasts: 3}), 'Le mail pour activer le compte aurait dû être envoyé.'

    # Mail pour annoncer le candidat à Phil
    assert_mail_exists?({
      subject:    I18n.t('user_mailer.candidature.nouvelle.subject'),
      to:         'phil@atelier-icare.net',
      from:       last_user.email,
      messages:   "#{last_user.name} (##{last_user.id})"
      },
      {lasts: 3, failure: 'Le mail pour annoncer le candidat aurait dû être envoyé à Phil.'})

    assert_mail_exists?({
      subject:  I18n.t('user_mailer.candidature.confirmation.subject'),
      to:       last_user.email,
      from:     'admin@atelier-icare.net'
      },
      {lasts: 3, failure: 'Le mail de confirmation de la candidature aurait dû être envoyé au candidat.'}
    )


    # Un ticket pour activer son compte a été créé
    tck = Ticket.where(name: I18n.t('tickets.titres.activer_compte'), user_id: last_user.id).last
    assert_not_nil(tck, 'Un ticket d’activation de compte aurait dû être créé pour le candidat…')
    # Un watcher pour le ticket doit avoir été créé
    aw = ActionWatcher.where(user_id: last_user.id, model: 'Ticket', model_id: tck.id)
    assert_not_nil(aw, 'Un watcher pour le ticket d’activation du compte devrait avoir été créé')


    # ---------------------------------------------------------------------

    # On déconnecte l'user (car le bouton est trop dur à avoir)
    visit '/logout'



    # ---------------------------------------------------------------------
    # ------- SUITE DU TEST (validation du mail) -----------

    # L'user utilise son mail pour valider son ticket
    visit full_href_for(tck.route)

    # Un message doit annoncer à l'user qu'il
    assert_equal(I18n.t('users.success.compte_actived', {name: last_user.name}), flash[:info])
    assert_text(I18n.t('users.success.compte_actived', {name: last_user.name}))

    # Maintenant, l'user doit être activé
    last_user.reload
    assert last_user.compte_actif?, 'Le compte du candidat devrait être activé'
    assert_equal(1, last_user.option(1), 'Le 2e bit d’option de l’user devrait être passé à 1.')

  end
end
