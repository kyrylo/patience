require_relative 'area'

module Patience
  ###
  # Patience::Area::Waste is a class, which represents Waste area of the game.
  # The goal of Waste is to hold visible cards, that are available for a player.
  # Waste refills itself with the cards from Stock.
  class Waste < Area

    def initialize(cards=[], piles_num=1)
      super(cards, piles_num)
      self.pos = [141, 23]
    end

  end
end
