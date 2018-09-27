require 'test_helper'

class IcModulesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get ic_modules_show_url
    assert_response :success
  end

  test "should get update" do
    get ic_modules_update_url
    assert_response :success
  end

  test "should get new" do
    get ic_modules_new_url
    assert_response :success
  end

  test "should get create" do
    get ic_modules_create_url
    assert_response :success
  end

end
