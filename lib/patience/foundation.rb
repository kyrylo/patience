require_relative 'area'

module Patience
  # Public: Represents Foundation area of the game.
  class Foundation < Area

    # Public: Create new Foundation.
    #
    # Examples
    #
    #   foundation = Area::Foundation.new
    #   foundation.piles.size
    #   #=> 1
    #
    # Returns nothing.
    def initialize
      super([], 4)
      self.pos = [356, 23]
    end

    protected

    # Internal: Dispose Foundation in the window by specifying coordinates of
    # every pile in this area, starting from the pos argument.
    #
    # pos - The Ray::Vector2 coordinate or the Array of X and Y coordinates.
    #
    # Returns nothing.
    def pos=(pos)
      x, y, step_x = pos[0], pos[1], 110
      foundation_bg = path_of('patience/sprites/foundation_bg.png')

      piles.each do |pile|
        pile.pos = [x, y]
        pile.background = Ray::Sprite.new foundation_bg
        x += step_x # Margin between piles along the axis X.
      end
    end

  end
end
