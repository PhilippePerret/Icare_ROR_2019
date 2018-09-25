require 'test_helper'

class TicketIntegrationTest < ActionDispatch::IntegrationTest

  def setup
    @phil = users(:phil)
    @benoit = users(:benoit)
  end

  test "Benoit peut créer un ticket et l'envoyer" do

    # get 'ticket/create'
  end

end
