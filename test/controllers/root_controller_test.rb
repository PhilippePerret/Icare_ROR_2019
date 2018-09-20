require "test_helper"


class RootControllerTest < ActionDispatch::IntegrationTest

  test "la page d'accueil répond correctement" do
    get root_url
    assert_response :success
    assert_select 'title', "Accueil | Atelier Icare"
    # Un lien contact existe
    assert_select 'a', "Contact", href: '/contactingnemarchepas'
    assert_select 'a', "Aide", href: '/helping'
  end

end
