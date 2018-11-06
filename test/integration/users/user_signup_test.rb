require "test_helper"

class AUserSignupWholeTest < ActionDispatch::IntegrationTest

  test 'Formulaire d’inscription' do
    get root_path
    assert_select('title', 'Atelier Icare')
  end

end
