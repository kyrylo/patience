require_relative 'pile'

module Patience
  ###
  # Patience::Tableau is a class, that holds cards distributed into piles. Each
  # pile is an individual instance of Patience::Pile class.
  class Tableau
    attr_reader :piles

    def initialize(cards, piles=7)
      # Initialize piles from the array of cards.
      @piles = piles.times.map { |i| cards.shift(i+1) }.map { |p| Pile.new(p) }

      x = 31 # X position of the first pile.
      @piles.each { |pile|
        pile.pos = [x, 165]
        x += 110 # Margin between piles along the axis X.

        y = 0    # Y position of the first card.
        pile.cards.each_with_index do |card, i|
          card.sprite.y += y
          y += 26 # Margin between cards along the axis Y.
          card.face_down unless pile.last_card?(i)
        end
      }
    end

  end
end
