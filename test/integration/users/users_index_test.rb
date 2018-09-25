require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @benoit = users(:benoit)
  end

  test "n'importe qui peut voir la liste des users (mais avec des infos réduites)" do
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    assert_select 'ul.pagination', count: 2
    assert_select 'li.previous_page.disabled', count: 2
    assert_select 'li.next_page', count: 2
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

end
