=begin
  Ce fichier est créé automatiquement quand on demande la création d'un
  test-système, par exemple avec :
    rails g[enerate] test_system Users
  Ces tests permettent de faire des tests d'intégration qu'on peut suivre
  visuellement (pas headless, ou le contraire)
=end
require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  # driven_by :selenium, using: :safari, screen_size: [1400, 1400]

  driven_by :selenium, using: :firefox, screen_size: [1400, 1400]
end
