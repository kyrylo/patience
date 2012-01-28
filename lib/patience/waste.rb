require_relative 'area'

module Patience
  ###
  # Patience::Area::Waste is a class, which represents Waste area of the
  # game. By now, it's backed up only with methods from the Area class.
  class Waste < Area

    # Instantiates Waste object.
    # Example:
    #   waste = Area::Waste.new
    #   waste.piles.size #=> 1
    #
    def initialize(cards=[], piles_num=1)
      super(cards, piles_num)
      self.pos = [141, 23]
    end

  end
end
