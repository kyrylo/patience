require_relative 'area'

module Patience
  ###
  # Patience::Area::Foundation is a class, which
  # represents Foundation area of the game.
  #   foundation = Area::Foundation.new
  #   foundation.piles.size #=> 1
  #
  class Foundation < Area

    def initialize
      super([], 4)
      self.pos = [361, 23]
    end

    protected

    # Disposes Foundation in the window by specifying coordinates
    # of every pile in this area, starting from the pos argument.
    def pos=(pos)
      x, y, step_x = pos[0], pos[1], 110
      piles.each do |pile|
        pile.pos = [x, y]
        x += step_x # Margin between piles along the axis X.
      end
    end

  end
end
