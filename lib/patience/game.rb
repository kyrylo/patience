module Patience
  class Game < Ray::Game
    def initialize
      super("Patience", :size => [800, 600])
      Patience::GameScene.bind(self)

      scenes << :game_scene
    end
  end
end
