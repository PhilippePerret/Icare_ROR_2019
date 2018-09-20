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
end
