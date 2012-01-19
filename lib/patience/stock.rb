require_relative 'area'

module Patience
  ###
  # Patience::Area::Stock is a class, which holds unrevealed cards.
  class Stock < Area

    def initialize(cards, piles_num=1)
      super(cards, piles_num)
      @piles[0].cards += @cards.shuffle_off!(24)
      self.pos = [31, 23]
    end

  end
end
