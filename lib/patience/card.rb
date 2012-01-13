module Patience
  ###
  # Patience::Card is a card creator class. Cards have ranks and suits. Every
  # card has its own sprite. Sprite is a one big image, that contains all cards.
  # A sprite for a card is chosen by shift on the sprite. Shift is defined by
  # integer values on X and Y axis repsectively.
  class Card
    ###
    # Suit supplies only one method: #red?. The idea is that every actual suit
    # has its own class, which is inherited from Suit. Each suit class defines
    # its own #black? method dynamically.
    class Suit
      # Checks whether card is "red" (being not black).
      def red?; not black?; end
    end

    # This lambda defines new class, designed to be a child
    # of Suit and supplied with #black? method, contents of
    # which depends on the given argument "true_or_false".
    create_suit_class = lambda { |true_or_false|
      Class.new(Suit) do
        # Returns boolean value. For red suits the value
        # is "false". For black suits the value is "true".
        define_method :black? do
          true_or_false
        end

        # Returns plural string representation of the suit.
        def to_s
          "#{self.class.name.demodulize}s"
        end
      end
    }

    # Create classes for every suit.
    Heart   = create_suit_class.call(false)
    Diamond = create_suit_class.call(false)
    Spade   = create_suit_class.call(true)
    Club    = create_suit_class.call(true)

    extend Forwardable
    def_delegators :@sprite, :pos, :x, :y

    attr_reader :rank, :suit, :sprite

    SUITS = [:hearts, :diamonds, :spades, :clubs]
    RANKS = [2, 3, 4, 5 ,6 ,7 ,8 ,9, 10, :jack, :queen, :king, :ace]

    def initialize(rank, suit)
      @rank   = rank
      @suit = case suit
              when 1 then Heart.new
              when 2 then Diamond.new
              when 3 then Spade.new
              when 4 then Club.new
              end
      @sprite = Ray::Sprite.new path_of('patience/sprites/card_deck.png')
      # A sheet with 13 columns and 5 rows. First
      # row and column corresponds to the card back.
      @sprite.sheet_size = [13, 5]
      @sprite.sheet_pos = [rank, suit]
    end

    # Prints human readable rank and suit of
    # the card. For example: "ace of spades".
    def to_s
      "#{RANKS[@rank]} of #{suit}"
    end

    # Turns a card to its face.
    def face_up
      sprite.sheet_pos = [@rank, @suit]
    end

    # Checks if a card is turned to its face.
    # The opposite of #face_down? method.
    def face_up?
      !self.face_down?
    end

    # Turns a card to its back.
    def face_down
      sprite.sheet_pos = [0, 0]
    end

    # Checks if a card is turned to its back.
    def face_down?
      sprite.sheet_pos == [0, 0]
    end

    # Either turns a card to its face if it's faced
    # down or turns it to its back if it's faced up.
    def flip!
      (face_up if face_down?) or (face_down if face_up?)
    end

  end
end
