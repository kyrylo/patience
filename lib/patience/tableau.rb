require_relative 'area'

module Patience
  ###
  # Patience::Area::Foundation is a class, which represents Tableau area of the
  # game. Every ordinary Tableau should have 7 piles and 28 cards in them. Each
  # pile has 1 + "serial number of the pile" cards. Every last card in every
  # pile is turned to its face. The other cards are face down.
  #   cards = []
  #   cards = 28.times { cards << Card.new(1, 1) }
  #   tableau = Tableau.new(cards)
  #   tableau.piles.size #=> 7
  #   tableau.cards.size #=> 28
  #
  class Tableau < Area

    def initialize(cards)
      super(cards, 7)
      @piles.each_with_index { |pile, i| pile.cards += @cards.shuffle_off!(i+1) }
      self.pos = [31, 165]
    end

    protected

    # Disposes Tableau in the window by specifying coordinates
    # of every pile in this area, starting from the pos argument.
    def pos=(pos)
      x, y, step_x, step_y = pos[0], pos[1], 110, 26
      piles.each { |pile|
        pile.pos = [x, y]
        x += step_x # Margin between piles along the axis X.
        y2 = 0 # Y position of the first card.
        pile.cards.each_with_index do |card, i|
          card.sprite.y += y2
          y2 += step_y # Margin between cards along the axis Y.
          card.face_down unless pile.last_card?(card)
        end
      }
    end

  end
end
