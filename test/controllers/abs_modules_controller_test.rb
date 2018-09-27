require 'test_helper'

class AbsModulesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get abs_modules_url
    assert_response :success
  end

end
