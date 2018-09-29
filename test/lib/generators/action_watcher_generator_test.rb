require 'test_helper'
require 'generators/action_watcher/action_watcher_generator'

class ActionWatcherGeneratorTest < Rails::Generators::TestCase
  tests ActionWatcherGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
