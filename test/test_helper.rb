ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# Ajouté du tutoriel pour les reporteurs
require 'minitest/reporters'
Minitest::Reporters.use!
# /ajout

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Ajout pour pouvoir utiliser les helper d'application
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...

  def is_logged_in?
    !session[:user_id].nil?
  end

  # Identification quand on est en test unitaire
  def log_in_as(user)
    session[:user_id] = user.id
  end
end


class ActionDispatch::IntegrationTest

  # Identification quand on est en test d'intégration
  def log_in_as(user, password: 'mot de passe', remember_me: '1')
    post login_path params:{session:{email: user.email, password: password,
      remember_me: remember_me}}
  end

end
