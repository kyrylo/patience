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
        pile.pos = [x, 150]
        x += 110 # Margin between piles along the axis X.

        y = 0    # Y position of the first card.
        pile.cards.each do |card|
          card.sprite.y += y
          y += 26 # Margin between cards along the axis Y.
        end
      }
    end

    # Iterate over each background in
    # Tableau, yielding it to the block.
    def each_background
      @piles.each { |pile| yield(pile.background) }
    end

  end
end
