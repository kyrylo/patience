require_relative '../helper'

module Patience
  class TestGameScene < MiniTest::Unit::TestCase

    def setup
      @game = Patience::Game.new
      @scene = @game.registered_scene(:game_scene)
      @scene.register
      @scene.setup
    end

  end
end
