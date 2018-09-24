require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:benoit)
    @marion = users(:marion)
  end

  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "edit ne peut être atteint sans être loggué (before_action)" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "update ne peut pas être atteint sans être loggué (before_action)" do
    patch user_path(@user), params:{user:{email:@user.email, name:@user.name}}
    assert_redirected_to login_path
  end

end
