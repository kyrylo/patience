module Patience
  ###
  # Patience::Card is a card creator class. Cards have ranks and suits. Every
  # card has its own sprite. Sprite is a one big image, which contains every
  # play card in the game. A sprite for a card is chosen by shift on the sprite.
  # The shift is determined by integer values on X and Y axis repsectively.
  #   card = Card(13, 3)
  #   card.to_s #=> "Ace of Spades"
  #   card.face_down
  #   card.face_up? #=> false
  #
  class Card
    extend Forwardable

    attr_reader :rank, :suit, :sprite

    # Creates new card object. Both arguments should be Fixnums
    # in the valid ranges. Also, every card has its sprite, which
    # is nothing but an instance of the Ray::Sprite class.
    def initialize(rank, suit)
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

    # Prints human readable rank and suit of the card.
    def to_s
      "#{rank} of #{suit}"
    end

    # Turns the card to its face.
    def face_up
      sprite.sheet_pos = [rank.to_i, suit.to_i]
    end

    # The opposite of the Card#face_down? method. Returns true
    # if the card is turned to its face. Otherwise, returns false.
    def face_up?
      self.not.face_down?
    end

    # Turns the card to its back (sets position of the sprite to zero values).
    def face_down
      sprite.sheet_pos = [0, 0]
    end

    # Returns true if the card is turned to its back (it means, that the
    # sprite of the card is set position of zero). Otherwise, returns false.
    def face_down?
      sprite.sheet_pos == [0, 0]
    end

    # Either turns the card to its face if it's faced
    # down or turns it to its back if it's faced up.
    def flip!
      (face_up if face_down?) or (face_down if face_up?)
    end

    # Draws the sprite of card in the window.
    def draw_on(win)
      win.draw(sprite)
    end

    # Compares two cards with each other, concerning their ranks.

    def eql?(other_card)
      self.rank == other_card.rank && self.suit == other_card.suit
    end

    def_delegators :@sprite, :pos, :pos=, :x, :y, :to_rect
    def_delegator  :@sprite, :collide?, :overlaps?
    def_delegator  :"@sprite.to_rect", :contain?, :hit?

    class DefunctRank < StandardError; end
    class DefunctSuit < StandardError; end
  end
end
