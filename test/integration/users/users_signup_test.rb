require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    @page_titre = "Poser sa candidature"
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

end
