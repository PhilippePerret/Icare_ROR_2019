require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test "L'utilisateur peut atteindre la page de login" do
    get login_path
    assert_response :success
  end

end
