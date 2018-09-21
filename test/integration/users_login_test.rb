require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  # Test de l'identification de l'user
  test 'Un user donnant les données valides s’identifie' do
    
  end

  # test avec des mauvaises données
  test 'De mauvaises données empêchent de s’identifier' do
    get login_path
    assert_select 'form[action="/login"]'
    post login_path, params: { session: {
      email: 'Bad email',
      password: 'bad password'
    }}
    assert_template 'sessions/new'
    assert_not flash.empty?
    # On vérifie aussi que le message d'erreur n'est pas répété
    get root_path
    assert flash.empty?
  end
end
