require 'test_helper'

class BureauControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get bureau_url
    assert_response :success
  end

  test "should get historique" do
    get historique_url
    assert_response :success
  end

  test "should get documents" do
    get documents_url
    assert_response :success
  end

end
