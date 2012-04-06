require_relative 'area'

module Patience
  ###
  # Patience::Area::Waste is a class, which represents Waste area of the
  # game. By now, it's backed up only with methods from the Area class.
  #   waste = Area::Waste.new
  #   waste.piles.size #=> 1
  #
  class Waste < Area

    def initialize
      super([], WASTE['piles'])
      self.pos = WASTE['position'].values
      self.piles[0].background = Ray::Sprite.new # Emptiness.
    end

  end
end
