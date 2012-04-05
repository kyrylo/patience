module Patience
  # Public: Card is a card creator class. Cards have ranks and suits. Every card
  # has its own sprite. A sprite is a one big image, which contains every play
  # card in the game. A sprite for a card is chosen by shift on the sprite. The
  # shift is determined by Integer values on X and Y axis repsectively.
  #
  # Examples
  #
  #   card = Card.new(13, 3)
  #   card.to_s
  #   #=> "Ace of Spades"
  #   card.face_down
  #   card.face_up?
  #   #=> false
  class Card
    extend Forwardable

    attr_reader :rank, :suit, :sprite

    # Public: Create the new card object. Every card has its sprite, which is
    # nothing but an instance of the Ray::Sprite class.
    #
    # rank - The Integer number between 1 and 13.
    # suit - The Integer number between 1 and 4.
    #
    # Examples
    #
    #   Card.new(1, 1)
    #   #=> Ace of Hearts
    #
    # Returns nothing.
    # Raises DefunctRank if the rank doesn't range from 1 to 13.
    # Raises DefunctSuit if the suit doesn't range from 1 to 4.
    def initialize(rank, suit)
      @rank = case rank
                when 1  then Rank::Ace.new
                when 2  then Rank::Two.new
                when 3  then Rank::Three.new
                when 4  then Rank::Four.new
                when 5  then Rank::Five.new
                when 6  then Rank::Six.new
                when 7  then Rank::Seven.new
                when 8  then Rank::Eight.new
                when 9  then Rank::Nine.new
                when 10 then Rank::Ten.new
                when 11 then Rank::Jack.new
                when 12 then Rank::Queen.new
                when 13 then Rank::King.new
              else
                raise DefunctRank, "Nonexistent rank: #{rank}"
              end
      @suit = case suit
                when 1 then Suit::Heart.new
                when 2 then Suit::Diamond.new
                when 3 then Suit::Spade.new
                when 4 then Suit::Club.new
              else
                raise DefunctSuit, "Nonexistent suit: #{suit}"
              end
      @sprite = Ray::Sprite.new path_of('patience/sprites/card_deck.png')
      # A sheet with 14 columns and 5 rows. First row and column
      # corresponds to the card back (their coordinats are equal to [0, 0]).
      @sprite.sheet_size = [14, 5]
      @sprite.sheet_pos = [rank, suit]
    end

    # Public: Print human readable representation of the card.
    #
    # Examples
    #
    #   card.to_s
    #   #=> "Ace of Hearts"
    #
    # Returns the String representation of the card, containing rank and suit
    # information.
    def to_s
      "#{rank} of #{suit}"
    end

    # Public: Turn the card to its face.
    #
    # Returns the Array with Suit and Rank objects of the card.
    def face_up
      sprite.sheet_pos = [rank.to_i, suit.to_i]
    end

    # Public: Check, whether the card is turned to its face or not. The opposite
    # of the Card#face_down? method.
    #
    # Returns true if the card is turned to its face or false otherwise.
    def face_up?
      self.not.face_down?
    end

    # Public: Turn the card to its back (set position of the sprite to zero
    # values, that corresponds to card's back sprite).
    #
    # Returns the Array with Suit and Rank objects of the card.
    def face_down
      sprite.sheet_pos = [0, 0]
    end

    # Public: Check, whether the card is turned to its back or not.
    #
    # Returns true if the card is turned to its back or false otherwise.
    def face_down?
      sprite.sheet_pos == [0, 0]
    end

    # Public: Either turn the card to its face if it's faced down or turn it to
    # its back if it's faced up.
    #
    # Returns the Array with Suit and Rank objects of the card.
    def flip!
      (face_up if face_down?) or (face_down if face_up?)
    end

    # Public: Draw the sprite of the card in the window.
    #
    # win - The Ray::Window object, which handles drawing.
    #
    # Examples
    #
    #   card.draw_on(Ray::Window.new)
    #
    # Returns nothing.
    def draw_on(win)
      win.draw(sprite)
    end

    # Public: Compare two cards with each other, considering their rank and suit
    # equality.
    #
    # other_card - The Card object.
    #
    # Examples
    #
    #   ace1 = Card.new(1, 1)
    #   ace2 = Card.new(1, 1)
    #   two  = Card.new(2, 1)
    #
    #   ace1.eql?(ace2)
    #   #=> true
    #   ace1.eql?(two)
    #   #=> false
    #
    # Returns true if the card is equal to other_card or false otherwise.
    def eql?(other_card)
      (@rank == other_card.rank) and (@suit == other_card.suit)
    end

    # Public: Check if the card overlaps other_card in the window.
    #
    # other_card - The Card object.
    #
    # Example
    #
    #   ace.overlaps?(two)
    #   #=> true
    #
    # Returns true if the card overlaps other_card or false otherwise.
    def overlaps?(other_card)
      sprite.collide?(other_card.sprite) and self.not.eql?(other_card)
    end

    def_delegators :@sprite, :pos, :pos=, :x, :y, :to_rect,
                   :sprite_width, :sprite_height
    def_delegator  :"@sprite.to_rect", :contain?, :hit?

    class DefunctRank < StandardError; end
    class DefunctSuit < StandardError; end
  end
end
