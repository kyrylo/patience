module Patience
  ###
  # Patience::Card is a card creator class. Cards have ranks and suits. Every
  # card has its own sprite. Sprite is a one big image, that contains all cards.
  # A sprite for a card is chosen by shift on the sprite. Shift is defined by
  # integer values on X and Y axis repsectively.
  class Card
    class Suit
      def red?
        not black?
      end
    end

    extend Forwardable
    def_delegators :@sprite, :pos, :x, :y

    attr_reader :rank, :suit, :sprite

    SUITS = [:hearts, :diamonds, :spades, :clubs]
    RANKS = [2, 3, 4, 5 ,6 ,7 ,8 ,9, 10, :jack, :queen, :king, :ace]

    def initialize(rank, suit)
      @rank   = rank
      @suit   = suit
      @sprite = Ray::Sprite.new path_of('patience/sprites/card_deck.png')
      # A sheet with 13 columns and 5 rows. First
      # row and column corresponds to the card back.
      @sprite.sheet_size = [13, 5]
      @sprite.sheet_pos = [rank, suit]
    end

    # Print human readable rank and suit of
    # the card. For example: "ace of spades".
    def to_s
      "#{RANKS[@rank]} of #{SUITS[@suit-1]}"
    end

    # Check whether card is "red" (being
    # in suit of either hearts or diamonds).
    def red?
      suit == 1 or suit == 2
    end

    # Check whether card is "black" (being
    # in suit of either spades or clubs).
    # The opposite of #red? method.
    def black?
      !self.red?
    end

    # Turn a card to its face.
    def face_up
      sprite.sheet_pos = [@rank, @suit]
    end

    # Check if a card is turned to its face.
    # The opposite of #face_down? method.
    def face_up?
      !self.face_down?
    end

    # Turn a card to its back.
    def face_down
      sprite.sheet_pos = [0, 0]
    end

    # Check if a card is turned to its back.
    def face_down?
      sprite.sheet_pos == [0, 0]
    end

    # Either turn a card to its face if it's faced
    # down or turn it to its back if it's faced up.
    def flip!
      (face_up if face_down?) or (face_down if face_up?)
    end

  end
end
