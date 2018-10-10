require 'test_helper'

class PaiementControllerTest < ActionDispatch::IntegrationTest
  test "should get proc" do
    get paiement_proc_url
    assert_response :success
  end

  test "should get ok" do
    get paiement_ok_url
    assert_response :success
  end

  test "should get cancel" do
    get paiement_cancel_url
    assert_response :success
  end

end
