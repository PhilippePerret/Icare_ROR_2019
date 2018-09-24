require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # NOTE : Quand on passe tous les tests, bizarrement, ça ne repasse pas
  # par la méthode setup (même en changeant le nom '@phil' par '@phila' par
  # exemple). Donc je suis contraint de définir les valeurs dans chaque cas.
  
  def setup
    @phil   = User.find_by(email: 'phil@atelier-icare.net')
    @marion = User.find_by(email: 'marion.michel31@free.fr')
    @user   = User.paginate(page: 1).last
  end

  test "Un administrateur est reconnu" do
    @phil   = User.find_by(email: 'phil@atelier-icare.net')
    @marion = User.find_by(email: 'marion.michel31@free.fr')
    @user   = User.paginate(page: 1).last
    assert @phil.admin?
    assert @marion.admin?
    assert_not @user.admin?
  end

  test "Un super-administrateur est reconnu" do
    @phil   = User.find_by(email: 'phil@atelier-icare.net')
    @marion = User.find_by(email: 'marion.michel31@free.fr')
    @user   = User.paginate(page: 1).last
    assert @phil.super_admin?
    assert      @marion.admin?
    assert_not  @marion.super_admin?
    assert_not  @user.super_admin?
  end

end
