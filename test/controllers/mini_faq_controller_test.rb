require 'test_helper'

class MiniFaqControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get mini_faq_create_url
    assert_response :success
  end

  test "should get new" do
    get mini_faq_new_url
    assert_response :success
  end

  test "should get edit" do
    get mini_faq_edit_url
    assert_response :success
  end

  test "should get update" do
    get mini_faq_update_url
    assert_response :success
  end

end
