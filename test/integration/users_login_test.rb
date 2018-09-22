require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:benoit)
  end

  # Test de l'identification de l'user
  test 'Un user donnant les données valides s’identifie' do
    get root_path
    assert_select 'a', 'Connexion'
    get login_path
    assert_select 'form[action="/login"]'
    post login_path, params: {session: {
      email: @user.email, password: 'mot de passe'
      }}
    assert_redirected_to '/bureau'
    follow_redirect!
    assert_template 'bureau/home'
    assert_select 'a[href=?]',  login_path, count: 0
    assert_select 'a[href=?]',  logout_path
    assert_select 'a[href=?]',  profil_path
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

  test 'Un user enregistré peut se logguer et se délogguer' do
    get login_path
    assert_select 'form[action="/login"]'
    post login_path, params: { session: {
      email:    @user.email,
      password: 'mot de passe'
    }}
    follow_redirect!
    assert_template 'bureau/home'
    assert is_logged_in?
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path

    # L'user se déconnecte
    get logout_path
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
    assert_not is_logged_in?
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
  end
end
