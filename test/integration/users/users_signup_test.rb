require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    @page_titre = "Poser sa candidature"
    ActionMailer::Base.deliveries.clear
  end

  test "La page d'inscription présente le bon titre" do
    get signup_url
    assert_select 'title', full_title(@page_titre)
    assert_select 'h2', @page_titre
  end

  test "Un formulaire invalide ne permet pas de s'inscrire" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        # Noter qu'on ne peut pas tester avec des valeurs vides ou
        # trop mauvaise (pour les mails) à cause du paramètres `required: true`
        # posé sur les champs, qui permettent un contrôle immédiat (avant
        # soumission).
        user:{
          name: 'Un nom', email: 'bad!bon@bad.email',
          sexe: '0', birthyear: '1998',
          password: 'foo', password_confirmation: 'bar'
        }
      }
    end
    assert_template 'users/new'
    assert_template 'shared/_error_messages'
    assert_select 'div#error_explanation'
  end
  # /test

  test "Un formulaire valide permet une candidature de l'user" do
    nowi = Time.now.to_i
    lename = "Le nom à #{nowi}"
    assert_difference 'User.count', 1 do
      get signup_url
      post users_path, params: {
        user: {
          name: lename,
          prenom: 'Maurice',
          nom: "À#{nowi}",
          email: "email#{nowi}@example.com",
          sexe: '1',
          birthyear: '1996',
          password: 'mot de passe',
          password_confirmation: 'mot de passe'
        }
      }
    end
    assert_not is_logged_in? # PAS ENCORE LOGGUÉ
    follow_redirect!
    assert_template 'static_pages/after_signup'
    # assert_select 'h2', 'Candidature enregistrée'
    # assert_select 'div', /#{lename}, votre candidature/
  end
  # test formulaire OK

  test "Inscription valide avec activation du compte" do
    get signup_url

    nowi = Time.now.to_i
    lename = "Maurice A#{nowi}"
    post users_path, params:{user:{
      name: lename,
      prenom: 'Maurice',
      nom: "À#{nowi}",
      email: "email#{nowi}@example.com",
      sexe: '0',
      birthyear: '1992',
      password: 'mot de passe',
      password_confirmation: 'mot de passe'
      }}

    nuser   = assigns(:user) # récupérer l'user
    token   = nuser.ticket_token # il faut le prendre tout de suite

    # Il ne doit pas être loggué
    assert_not is_logged_in?
    follow_redirect!
    assert_template 'static_pages/after_signup'

    # S'il essaie de se logguer, ça ne fonctionne pas
    log_in_as(nuser)
    assert_not is_logged_in?
    follow_redirect!
    assert_select 'div.alert', /rien faire avant d’avoir confirmé votre email/

    # Un mail doit avoir été délivré
    assert_equal 1, ActionMailer::Base.deliveries.size # ne fonctionne pas

    # Ses options portent bien la marque voulue
    ticket  = Ticket.last
    assert_not_nil ticket

    # nuser = User.last
    nuser.reload
    assert_not nuser.compte_actif?, 'son compte n’est pas actif'

    # Il va maintenant confirmer son inscription

    # Avec un mauvais identifiant
    get ticket_run_path(100000000, token: token)
    nuser.reload
    assert_not nuser.compte_actif?, 'son compte n’est pas actif'
    assert_redirected_to home_path
    follow_redirect!

    # Avec un mauvais token
    get ticket_run_path(ticket.id, token: 'bad token')
    nuser.reload
    assert_not nuser.compte_actif?, 'son compte n’est pas actif'
    assert_redirected_to home_path
    follow_redirect!

    # Avec le bon ticket
    get ticket_run_path(ticket.id, token: token)
    nuser.reload
    assert_redirected_to home_path
    follow_redirect!
    # Le compte est actif, mais il faut se logguer
    assert nuser.compte_actif?, 'son compte doit être actif'
    assert_not is_logged_in?

    log_in_as(nuser)
    assert is_logged_in?

  end
end
