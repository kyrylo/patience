module Patience
  ###
  # Patience::Card is a card creator class. Cards have ranks and suits.
  # Every card has its own sprite. Sprite is a one big image, that contains
  # all cards. A sprite for a card is chosen by shift on the sprite. Shift
  # is defined by integer values on X and Y axis repsectively.
  class Card
    ###
    # Rank class provides underlying methods for every rank.
    class Rank
      ##
      # This lambda defines new class, designed to be a child of Rank.
      create_rank_class = lambda { |num|
        Class.new(Rank) do

          define_method :initialize do
            @num = num
          end

          # Returns integer representation of a rank. Basically, it's
          # the position of a card in the ascending row of card ranks.
          # Example:
          #   card = Card.new(13, 3) #=> Ace of Spades
          #   card.rank.to_i #=> 13
          #
          def to_i
            @num
          end

          # Returns string representation of a rank. It asks class to
          # give its full name, exscinding everything but its actual name.
          # Example:
          #   card = Card.new(13, 3) #=> Ace of Spades
          #   card.rank.to_s #=> "Ace"
          #
          def to_s
            "#{self.class.name.demodulize}"
          end
        end
      }

      # Dynamically create rank classes.
      %w[Two Three Four Five Six Seven
         Eight Nine Ten Jack Queen King Ace].each_with_index do |class_name, i|
        Rank.const_set(class_name, create_rank_class.call(i))
      end
    end

    ###
    # Suit supplies only one method: #red?. The idea is that every
    # actual suit has its own class, which is inherited from Suit.
    # Each suit class defines its own #black? method dynamically.
    class Suit
      ##
      # This lambda defines new class, designed to be a child
      # of Suit and supplied with #black? method, contents of
      # which depends on the given argument "true_or_false".
      create_suit_class = lambda { |num, true_or_false|
        Class.new(Suit) do

          define_method :initialize do
            @num = num
          end

          # Returns boolean value. For red suits the value
          # is "false". For black suits the value is "true".
          # Example:
          #   card = Card.new(13, 3) #=> Ace of Spades
          #   card.suit.black? #=> true
          #
          define_method :black? do
            true_or_false
          end

          # Returns integer representation of a suit.
          # Example:
          #   card = Card.new(13, 3) #=> Ace of Spades
          #   card.suit.to_i #=> 3
          #
          def to_i
            @num
          end

          # Returns plural string representation of a suit. It asks class to
          # give its full name, exscinding everything but its actual name.
          # Example:
          #   card = Card.new(13, 3) #=> Ace of Spades
          #   card.suit.to_s #=> "Spades"
          #
          def to_s
            "#{self.class.name.demodulize}s"
          end

        end
      }

      # Create classes for every suit, giving the answer on the question about
      # their blackness. If the answer is negative, obviously the suit is red.
      Heart   = create_suit_class.call(1, false)
      Diamond = create_suit_class.call(2, false)
      Spade   = create_suit_class.call(3, true)
      Club    = create_suit_class.call(4, true)

      # Checks whether card is "red" (being not black).
      def red?; not black?; end
    end

    extend Forwardable

    attr_reader :rank, :suit, :sprite

    def initialize(rank, suit)
      # Supply every suit and rank with its numerical alias.
      @rank = case rank
              when 1  then Rank::Two.new
              when 2  then Rank::Three.new
              when 3  then Rank::Four.new
              when 4  then Rank::Five.new
              when 5  then Rank::Six.new
              when 6  then Rank::Seven.new
              when 7  then Rank::Eight.new
              when 8  then Rank::Nine.new
              when 9  then Rank::Ten.new
              when 10 then Rank::Jack.new
              when 11 then Rank::Queen.new
              when 12 then Rank::King.new
              when 13 then Rank::Ace.new
              else raise DefunctRank, "Nonexistent rank: #{rank}"
              end
      @suit = case suit
              when 1 then Suit::Heart.new
              when 2 then Suit::Diamond.new
              when 3 then Suit::Spade.new
              when 4 then Suit::Club.new
              else raise DefunctSuit, "Nonexistent suit: #{suit}"
              end
      @sprite = Ray::Sprite.new path_of('patience/sprites/card_deck.png')
      # A sheet with 13 columns and 5 rows. First
      # row and column corresponds to the card back.
      @sprite.sheet_size = [13, 5]
      @sprite.sheet_pos = [rank-1, suit]
    end

    # Prints human readable rank and suit of the card.
    # Example:
    #   ace = Card.new(13, 3)
    #   ace.to_s #=> "Ace of Spades"
    #
    def to_s
      "#{rank} of #{suit}"
    end

    # Turns a card to its face.
    def face_up
      sprite.sheet_pos = [rank.to_i, suit.to_i]
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

    # Draws the sprite of card in the 'win'.
    def draw_on(win)
      win.draw(sprite)
    end

    def_delegators :@sprite, :pos, :x, :y, :to_rect
    def_delegator  :"@sprite.to_rect", :contain?, :hit?

    class DefunctRank < StandardError; end
    class DefunctSuit < StandardError; end
  end
end
