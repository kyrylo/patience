module Patience
  ###
  # Patience::Card is a card creator class. Cards have ranks and suits. Every
  # card has its own sprite. Sprite is a one big image, that contains all cards.
  # A sprite for a card is chosen by shift on the sprite. Shift is defined by
  # integer values on X and Y axis repsectively.
  class Card
    extend Forwardable
    def_delegators :@sprite, :pos, :x, :y

    attr_reader :rank, :suit, :sprite

    SUITS = [:hearts, :diamonds, :spades, :clubs]
    RANKS = [2, 3, 4, 5 ,6 ,7 ,8 ,9, 10, :jack, :queen, :king, :ace]

    def initialize(rank, suit)
      @rank   = rank
      @suit   = suit
      @sprite = Ray::Sprite.new path_of('patience/sprites/card_deck.png')
      @sprite.sheet_size = [13, 5]
      @sprite.sheet_pos = [rank, suit]
    end

    def to_s
      "#{RANKS[@rank]} of #{SUITS[@suit-1]}"
    end

    def red?
      suit == 1 or suit == 2
    end

    def black?
      !self.red?
    end

  end
end
