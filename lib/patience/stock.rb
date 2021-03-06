require_relative 'area'

module Patience
  ###
  # Patience::Area::Stock creates Stock game object. By now, it's backed up only
  # with methods from the Area class. Every card in Stock is turned to its back.
  #   stock = Area::Stock.new
  #   stock = Area::Stock.new([Card.new(1, 1)])
  #   stock.cards[0].face_down? #=> true
  #
  class Stock < Area

    def initialize(cards)
      super(cards, STOCK['piles'])
      self.piles.first.cards += @cards.shuffle_off!(24).each(&:face_down)
      self.pos = STOCK['position'].values
    end

  end
end
