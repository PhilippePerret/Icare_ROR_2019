require 'test_helper'

# class UserResetPassword < ActionDispatch::IntegrationTest
#
#   def setup
#     @benoit = users(:benoit)
#     # log_in_as(@benoit)
#     @marion = users(:marion)
#   end
#
#   # Test du changement de mot de passe d'un user.
#
#   test "Un visiteur quelconque ne peut pas forcer le changement de mot de passe" do
#
#     get '/tickets/1/XojAuUy10pbCBdj8i3L5dw'
#     assert_select 'form', count: 0
#
#   end
#
#   test "Un icarien peut changer son mot de passe" do
#     get '/login'
#     assert_select 'a[href=?]', '/password_resets/new'
#
#   end
#
# end

class UserResetPasswordCapy < Capybara::Rails::TestCase

  test "un icarien peut changer son mot de passe" do

    def benoit
      @benoit ||= users(:benoit)
    end

    def setup
      @benoit = users(:benoit)
    end

    init_password_digest = benoit.password_digest
    assert BCrypt::Password.new(init_password_digest).is_password?('mot de passe')

    # Benoit parvient à se logguer avec son mot de passe actuel
    visit login_path
    fill_in 'session_email',    with: benoit.email
    fill_in 'session_password', with: 'mot de passe'
    click_on I18n.t('users.signin.button')
    assert page.has_content?('Bienvenue')


    # Benoit se déconnecte
    click_on 'Déconnexion'
    assert page.has_content?(I18n.t('users.success.goodbye', name: benoit.name))


    # Benoit clique sur le bouton du mot de passe oublié
    visit login_path
    click_on I18n.t('users.password.forgotten')


    # Benoit entre son adresse
    # fill_in('infopassword_email', with: @benoit.email)
    fill_in('infopassword_email', with: 'benoit.ackerman@yahoo.fr')
    click_on I18n.t('users.password.send_reset_code.button')

    # On récupère le dernier mail envoyé
    mail = ActionMailer::Base.deliveries.last
    # puts "mail: #{mail.inspect}"

    assert_equal I18n.t('user_mailer.reset_password.subject'), mail.subject
    # puts mail.body.methods
    # puts "mail.body.encoded: #{mail.body.encoded}\n\n"

    # On récupère l'url du ticket dans le mail
    ticket_url = mail.body.encoded.match(/"([^"]+)">Modifi/)[1]

    visit ticket_url
    assert_not page.has_content?("toto la bulle")
    assert page.has_title?('Nouveau mot de passe')
    assert page.has_content?(I18n.t('users.password.new.label'))
    assert page.has_content?(I18n.t('users.password.confirmation.label'))

    fill_in('newpass_password', with: 'autre mot de passe')
    fill_in('newpass_password_confirmation', with: 'autre mot de passe')
    click_on(I18n.t('users.password.change.button'))
    assert page.has_content?(I18n.t('password.success.reset') % {pseudo: benoit.name})

    benoit.reload

    # Benoit se déconnecte
    click_on 'Déconnexion'
    assert page.has_content?(I18n.t('users.success.goodbye', name: benoit.name))

    # À partir d'ici, le nouveau mot de passe est en fonction
    # On vérifie dans la base de donnée qu'il a bien été changé
    new_password_digest = benoit.password_digest
    assert_not_equal new_password_digest, init_password_digest
    assert BCrypt::Password.new(new_password_digest).is_password?('autre mot de passe')

    # Benoit ne peut pas se reconnecter avec son ancien mot de passe
    visit login_path
    fill_in 'session_email',    with: benoit.email
    fill_in 'session_password', with: 'mot de passe'
    click_on I18n.t('users.signin.button')
    assert page.has_no_content?('Bienvenue')

    # Benoit peut se connecter avec son nouveau mot de passe
    visit login_path
    fill_in 'session_email',    with: benoit.email
    fill_in 'session_password', with: 'autre mot de passe'
    click_on I18n.t('users.signin.button')
    assert page.has_content?('Bienvenue')

  end
end
