require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @site_name = "Atelier Icare"
  end

  test "should get home" do
    get home_url
    assert_response :success
    assert_select 'title', "#{@site_name}"
  end

  test "should get help" do
    get help_url
    assert_response :success
    assert_select 'title', "Aide | #{@site_name}"
  end

  test "possède une page d'à propos" do
    get about_url
    assert_response :success
    assert_select 'title', "À propos | #{@site_name}"
  end

  test "possède une page de contact" do
    get contact_url
    assert_response :success
    assert_select 'title', "Contact | #{@site_name}"
  end

end
