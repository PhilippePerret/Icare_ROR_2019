require 'test_helper'

class AbsEtapesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get abs_etapes_index_url
    assert_response :success
  end

  test "should get show" do
    get abs_etapes_show_url
    assert_response :success
  end

end
