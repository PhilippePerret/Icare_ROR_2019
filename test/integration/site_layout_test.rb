require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "liens communs" do
    get root_path

    # On vérifie que ce soit le bon template qui ait été chargé
    assert_template 'static_pages/home'

    # On vérifie les liens de base
    assert_select 'a[href=?]', home_path,     text: 'Accueil'
    assert_select 'a[href=?]', contact_path,  text: 'Contact'
    assert_select 'a[href=?]', about_path,    text: 'À propos'
    assert_select 'a[href=?]', help_path,     text: 'Aide'

  end
end
