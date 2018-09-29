require 'test_helper'

class ActionWatchersControllerTest < ActionDispatch::IntegrationTest
  test "doit pouvoir runner l'action-watcher" do
    get awrun_url(1)
    assert_response :success
  end

  test "doit pouvoir atteindre la méthode destroy" do
    delete action_watcher_url(2)
    assert_response :success
  end

  test "un simple user ne peut pas lancer un action-watcher" do
    
  end
  test "un user identifié ne peut pas lancer un action-watcher qui ne lui appartient pas" do

  end
  test "un user non administrateur ne peut pas détruire un user avec destroy" do

  end

end
