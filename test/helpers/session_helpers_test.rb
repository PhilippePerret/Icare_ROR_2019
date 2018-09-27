require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:benoit)
    remember(@user)
  end

  test "current_user retourne le bon user quand session est nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user retourne nil quand le remember digest est mauvais" do
    @user.update_attribute(:remember_digest, SessionsHelper.digest(SessionsHelper.new_token))
    assert_nil current_user
  end

end
