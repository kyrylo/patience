require_relative 'helper'

module Patience
  class TestGame < TestCase

    def setup
      @game = Patience::Game.new
      @scene = @game.registered_scene(:game_scene)
      @scene.register
      @scene.setup
    end

    test 'Window size of the game is eight hundred by six hundred pixels' do
      assert_equal Ray::Vector2[800, 600], @scene.window.size
    end

    test 'Test the game has GameScene' do
      assert_instance_of GameScene,
                         @game.scenes.to_a.find { |scene|
                           scene.instance_of? GameScene
                         }
    end

    test 'Main scene is GameScene' do
      assert_instance_of GameScene, @game.scenes.current
    end

  end
end
