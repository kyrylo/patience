require_relative 'area'

module Patience
  ###
  # Patience::Area::Foundation is a class, which represents Foundation area of
  # the game.
  class Foundation < Area

    def initialize(cards=[], piles_num=4)
      super(cards, piles_num)
      self.pos = [361, 23]
    end

    protected

    # Disposes Foundation.
    def pos=(pos)
      x, y, step_x = pos[0], pos[1], 110
      piles.each do |pile|
        pile.pos = [x, y]
        x += step_x # Margin between piles along the axis X.
      end
    end

  end
end
