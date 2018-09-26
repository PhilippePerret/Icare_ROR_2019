require 'test_helper'

class UserResetPassword < ActionDispatch::IntegrationTest

  def setup
    @benoit = users(:benoit)
    # log_in_as(@benoit)
    @marion = users(:marion)
  end

  # Test du changement de mot de passe d'un user.

  test "Un visiteur quelconque ne peut pas forcer le changement de mot de passe" do

    get '/tickets/1/XojAuUy10pbCBdj8i3L5dw'
    assert_select 'form', count: 0

  end

  test "Un icarien peut changer son mot de passe" do
    get '/login'
    assert_select 'a[href=?]', '/password_resets/new'
    
  end

end
