module Patience
  ###
  # Patience::Area provides area objects, that consist of piles. The goal of
  # this class is to assemble piles into a logical bundle with a few common
  # methods, so they could be controlled via only one interface. Basically,
  # this class is useless on its own. The purpose of Area is to be inherited
  # by other classes, which are more verbose in their intentions. By default,
  # Area object instantiates without any cards and only with one pile. Every
  # new pile would be created empty, even though you feed some cards to the
  # new object. All the cards you provide to the new object, wouldn't be
  # placed anywhere. You have to allocate them manually.
  #   field = Area.new
  #   field.piles #=> [#<Patience::Pile>]
  #   filed.piles[0].pos #=> (0, 0)
  #   field.pos #=> (0, 0)
  #
  class Area
    # Returns an array of piles in the area.
    attr_reader :piles

    def initialize(cards=[], piles_num=1)
      @piles = []
      @cards = Pile.new(cards)
      piles_num.times { @piles << Pile.new }
    end

    # Shows position of the area. The position of the very
    # first pile in the area, counts as its actual position.
    def pos
      piles.first.pos
    end

    # Sets the position of every pile in the area to the same value.
    def pos=(pos)
      piles.each { |pile| pile.pos = *pos }
    end

    # Collects all cards in every pile and returns the array of these
    # cards. If there are no cards in the area, returns an empty array.
    def cards
      piles.inject([]) { |cards, pile| cards << pile.cards }.flatten
    end

    # Draws each pile of the area in the window.
    def draw_on(win)
      piles.each { |pile| pile.draw_on(win) }
    end

    # Returns pile in the area, which has been
    # clicked. If there is no such, returns nil.
    def hit?(mouse_pos)
      piles.find { |pile| pile.hit?(mouse_pos) }
    end

    # Adds card from outer_pile to the very first
    # pile of the area, flipping it en route.
    def add_from(outer_pile, card)
      card.flip! and piles.first << outer_pile.remove(card)
    end

  end
end
