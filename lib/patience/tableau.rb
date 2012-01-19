require_relative 'area'

module Patience
  ###
  # Patience::Tableau is a class, that holds cards distributed into piles. Each
  # pile is an individual instance of Patience::Pile class.
  class Tableau < Area

    def initialize(cards, piles_num=7)
      super(cards, piles_num)
      @piles.each_with_index { |pile, i| pile.cards += @cards.shuffle_off!(i+1) }
      self.pos = [31, 165]
    end

    protected

    def pos=(pos)
      x, y, step_x, step_y = pos[0], pos[1], 110, 26
      piles.each { |pile|
        pile.pos = [x, y]
        x += step_x # Margin between piles along the axis X.
        y2 = 0 # Y position of the first card.
        pile.cards.each_with_index do |card, i|
          card.sprite.y += y2
          y2 += step_y # Margin between cards along the axis Y.
          card.face_down unless pile.last_card?(i)
        end
      }
    end

  end
end
