module Patience
  ###
  # Patience::Pile is aimed to hold cards in a pile :surprise:. Every pile has
  # its own background sprite.
  class Pile
    attr_accessor :cards, :background

    def initialize(cards)
      @cards = cards
      @background = Ray::Sprite.new path_of 'patience/sprites/pile_background.png'
    end

    # Throw off some quantity of cards.
    def shuffle_off(num)
      @cards.slice!(0..num-1)
    end

    # Get position of a pile. Applies to
    # the cards in a pile and background both.
    def pos
      @background.pos
    end

    # Set position of a pile. Applies to
    # the cards in a pile and background both.
    def pos=(pos)
      @background.pos = *pos
      @cards.each { |card| card.sprite.pos = *pos }
    end

    # Size of a pile.
    def size
      @cards.size
    end

  end
end
