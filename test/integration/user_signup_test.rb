require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  def setup
    @page_titre = "Poser sa candidature"
  end

  test "La page d'inscription présente le bon titre" do
    get signup_url
    assert_select 'title', full_title(@page_titre)
    assert_select 'h2', @page_titre
  end

end
