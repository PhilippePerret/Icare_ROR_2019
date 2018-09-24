require 'test_helper'

class DestroyUserControllerTest < ActionDispatch::IntegrationTest

  def setup
    @phil   = users(:phil)
    @marion = users(:marion)
    @benoit = users(:benoit)
    @lana   = users(:lana)
  end

  test "un simple visiteur ne peut pas détruire un utilisateur" do
    assert_equal '0', @benoit.options[0]
    assert_no_difference 'User.count' do
      delete user_path(@benoit)
    end
    assert_redirected_to login_path
    assert_not_equal '9', @benoit.options[0]

    assert_no_difference 'User.count' do
      delete user_path(@phil)
    end
    assert_redirected_to login_path
    assert_not_equal '9', @phil.options[0]
  end

  test "un icarien non administrateur ne peut pas détruire un autre icarien" do
    log_in_as(@benoit)
    assert_no_difference 'User.count' do
      delete user_path(@lana)
    end
    assert_not_equal '9', @lana.options[0]
  end

  test "un icarien non admin ne peut détruire un admin" do
    log_in_as(@benoit)
    assert_no_difference 'User.count' do
      delete user_path(@phil)
    end
    assert_not_equal '9', @phil.options[0]
  end

  test "un administrateur peut détruire un icarien" do
    log_in_as(@phil)
    assert_equal '0', @lana.options[0]
    assert_no_difference 'User.count' do
      delete user_path(@lana)
    end
    @lana.reload
    assert_equal '9', @lana.options[0]

  end

end
