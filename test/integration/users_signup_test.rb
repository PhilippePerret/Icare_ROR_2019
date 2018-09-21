require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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
          password: 'foo', password_confirmation: 'bar'
        }
      }
    end
    assert_template 'users/new'
    assert_template 'shared/_error_messages'
    assert_select 'div#error_explanation'
  end
  # /test
end
