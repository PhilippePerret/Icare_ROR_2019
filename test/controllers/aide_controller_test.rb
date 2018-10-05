require 'test_helper'

class AideControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get aide_show_url
    assert_response :success
  end

  test "should get index" do
    get aide_index_url
    assert_response :success
  end

  test "should get search" do
    get aide_search_url
    assert_response :success
  end

end
