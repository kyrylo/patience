require_relative 'helper'

module Patience
  class TestGame < MiniTest::Unit::TestCase

    def setup
      @game = Patience::Game.new
      @scene = @game.registered_scene(:game_scene)
      @scene.register
      @scene.setup
    end

    def test_window_size_of_the_game_is_eight_hundred_by_six_hundred_pixels
      assert_equal Ray::Vector2[800, 600], @scene.window.size
    end

  end
end
