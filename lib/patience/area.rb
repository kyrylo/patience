module Patience
  # Public: Provides area objects, that consist of piles. The goal of this class
  # is to assemble piles into a logical bundle with a few common methods, so
  # they could be controlled via only one interface. By default, Area object
  # instantiates without any cards and only with one pile. Every new pile would
  # be created empty, even though you feed some cards to the new object. You
  # have to allocate the cards between the piles manually.
  #
  # Examples
  #
  #   field = Area.new
  #   field.piles
  #   #=> [#<Patience::Pile>]
  #   filed.piles[0].pos
  #   #=> (0, 0)
  #   field.pos
  #   #=> (0, 0)
  class Area
    # Public: Returns an array of piles in the area.
    attr_reader :piles

    # Public: Initialize a new area.
    #
    # cards     - The Array of cards, to be allocated to the area (default: []).
    # piles_num - The Integer of piles, of what the area should consists
    #             (default: 1).
    #
    # Returns nothing.
    def initialize(cards=[], piles_num=1)
      @piles = []
      @cards = Pile.new(cards)
      piles_num.times { @piles << Pile.new }
    end

    # Public: Show position of the area. The position of the very
    # first pile in the area, counts as its actual position.
    #
    # Returns the new Ray::Vector2 coordinate.
    def pos
      piles.first.pos
    end

    # Public: Set the position of every pile in the area to the same value.
    #
    # pos - The Ray::Vector2 coordinate or the Array of X and Y coordinates.
    #
    # Examples
    #
    #   area.piles[2].pos
    #   #=> (20, 50)
    #   area.piles[0].pos
    #   #=> (0, 0)
    #
    #   # Set the position.
    #   area.pos = Ray::Vector2[100, 100]
    #   #=> (100, 100)
    #
    #   # Same effect, but different return value type.
    #   area.pos = [100, 100]
    #   #=> [100, 100]
    #
    # Returns either the Ray::Vector2 coordinate or the Array.
    def pos=(pos)
      piles.each { |pile| pile.pos = *pos }
    end

    # Public: Collect all cards in every pile and return the array of them.
    #
    # Examples
    #
    #   area.cards
    #   #=> [Ace of Spades, Three of Diamonds]
    #
    # Returns the Array of cards in the area.
    def cards
      piles.inject([]) { |cards, pile| cards << pile.cards }.flatten
    end

    # Public: Draw each pile of the area in the window.
    #
    # win - The Ray::Window object, which handles drawing.
    #
    # Examples
    #
    #   area.draw_on(Ray::Window.new)
    #
    # Returns nothing.
    def draw_on(win)
      piles.each { |pile| pile.draw_on(win) }
    end

    # Public: Check, whether Area received a click or not.
    #
    # mouse_pos - The Ray::Vector2 coordinate or the Array of X and Y
    #             coordinates.
    #
    # Examples
    #
    #   area.hit?(Ray::Vector2[100, 100])
    #   #=> true
    #
    #   # The same as:
    #   area.hit?([100, 100])
    #   #=> true
    #
    # Returns true if mouse_pos hit the Area or false otherwise.
    def hit?(mouse_pos)
      piles.find { |pile| pile.hit?(mouse_pos) }
    end

    # Public: Add the card from outer_pile to the very first pile of the area,
    # flipping it en route.
    #
    # outer_pile - The Pile, which should receive card.
    # card       - The Card, which should be added to outer_pile.
    #
    #   pile = Pile.new([Card.new(1, 1)])
    #   area.add_from(pile, pile.cards[0])
    #   #=> [Ace of Hearts]
    #
    # Returns the Array.of cards in the very first pile.
    def add_from(outer_pile, card)
      card.flip! and piles.first << outer_pile.remove(card)
    end

  end
end
