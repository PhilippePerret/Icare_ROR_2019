require 'test_helper'

class IcEtapesControllerTest < ActionDispatch::IntegrationTest
  test "should get set_document_sharing" do
    get ic_etapes_set_document_sharing_url
    assert_response :success
  end

end
