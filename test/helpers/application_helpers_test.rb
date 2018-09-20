require 'test_helper'

class ApplicationHelpersTest < ActionView::TestCase

  test "Titre principal pour balise TITLE" do
    assert_equal full_title, 'Atelier Icare'
    assert_equal full_title('Pour test'), 'Pour test | Atelier Icare'
  end
end
