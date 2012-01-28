require_relative 'area'

module Patience
  ###
  # Patience::Area::Stock creates Stock game object. By now,
  # it's backed up only with methods from the Area class.
  # Example:
  #   stock = Area::Stock.new
  #   stock = Area::Stock.new([Card.new(1, 1)])
  #
  class Stock < Area

    # Instantiate Stock object. The cards argument is
    # mandatory. Every card in Stock is turned to its back.
    # Example:
    #   stock = Area::Stock.new([Card.new(1, 1)])
    #   stock.cards[0].face_down? #=> true
    #
    def initialize(cards)
      super(cards, 1)
      @piles[0].cards += @cards.shuffle_off!(24).each(&:face_down)
      self.pos = [31, 23]
    end

  end
end
