require 'test_helper'

class IcDocumentsControllerTest < ActionDispatch::IntegrationTest
  test "should get download" do
    get ic_documents_download_url
    assert_response :success
  end

  test "should get show" do
    get ic_documents_show_url
    assert_response :success
  end

  test "should get edit" do
    get ic_documents_edit_url
    assert_response :success
  end

end
