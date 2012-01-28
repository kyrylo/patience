require_relative 'area'

module Patience
  ###
  # Patience::Area::Foundation is a class, which
  # represents Foundation area of the game.
  class Foundation < Area

    # Instantiates Foundation's parameters. Without any arguments,
    # creates Foundation with 4 piles and without any cards in there.
    # Example:
    #   foundation = Area::Foundation.new
    #   foundation.piles.size #=> 4
    #   unusual_foundation = Area::Foundation.new([], 2)
    #   unusual_foundation.piles.size #=> 2
    #
    def initialize(cards=[], piles_num=4)
      super(cards, piles_num)
      self.pos = [361, 23]
    end

    protected

    # Disposes Foundation in the window by specifying coordinates
    # of every pile in this area, starting from the pos argument.
    # Example:
    #  foundation = Area::Foundation.new
    #  foundation.pos = [10, 10]
    #  foundation.piles[0].pos #=> (10, 10)
    #
    def pos=(pos)
      x, y, step_x = pos[0], pos[1], 110
      piles.each do |pile|
        pile.pos = [x, y]
        x += step_x # Margin between piles along the axis X.
      end
    end

  end
end
