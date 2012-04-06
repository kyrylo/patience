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
      super([], FOUNDATION['piles'])
      #self.pos = [356, 23]
      self.pos = FOUNDATION['position'].values
    end

    protected

    # Internal: Dispose Foundation in the window by specifying coordinates of
    # every pile in this area, starting from the pos argument.
    #
    # pos - The Ray::Vector2 coordinate or the Array of X and Y coordinates.
    #
    # Returns nothing.
    def pos=(pos)
      x, y, step_x = pos[0], pos[1], FOUNDATION['indent']

      piles.each do |pile|
        pile.pos = [x, y]
        pile.background = Ray::Sprite.new image_path('foundation_bg')
        x += step_x # Margin between piles along the axis X.
      end
    end

  end
end
