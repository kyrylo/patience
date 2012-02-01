module Patience
  ###
  # Patience::Area provides area objects, that consist of piles. The goal of
  # this class is to assemble piles into a logical bundle with a few common
  # methods, so they could be controlled via only one interface. Basically,
  # this class is useless on its own. The purpose of Area is to be inherited
  # by other classes, which are more verbose in their intentions.
  # Examples:
  #   # Creating a generic Area:
  #   field = Area.new
  #   field.piles #=> [#<Patience::Pile>]
  #
  class Area
    # Returns an array of piles in the area.
    attr_reader :piles

    # Instantiates an Area object. The argument 'cards' is an array of cards
    # and the 'piles_num' is a Fixnum number, which describes how many piles
    # should be created within that area. By default, Area object instantiates
    # without any cards and only with one pile. Every new pile would be created
    # empty, even though you feed some cards to the new object. All the cards
    # you provide to the new object, would be placed in the very first pile
    # Example:
    #   cards = [Card.new(1, 1)]
    #   field = Area.new(cards, 1])
    #   field = Area.new(cards)
    #   field = Area.new(cards, 10)
    #
    def initialize(cards=[], piles_num=1)
      @piles = []
      @cards = Pile.new(cards)
      piles_num.times { @piles << Pile.new }
    end

    # Shows position of the area. The position of the very
    # first pile in the area, counts as its actual position.
    # Example:
    #   field = Area.new
    #   field.pos = [10, 100]
    #   field.pos #=> (10.0, 100.0)
    #
    def pos
      piles.first.pos
    end

    # Sets the position of every pile in the area to the same value.
    # Example:
    #   field = Area.new([], 2)
    #   field.piles[0].pos #=> (0.0, 0.0)
    #   field.pos = [10, 100]
    #   field.piles[0].pos #=> (10.0, 100.0)
    #   field.piles[1].pos #=> (10.0, 100.0)
    #
    def pos=(pos)
      piles.each { |pile| pile.pos = *pos }
    end

    # Draws each pile of the area in the window.
    # Example:
    #   field = Area.new
    #   field.draw_on(window)
    #
    def draw_on(win)
      piles.each { |pile| pile.draw_on(win) }
    end

  end
end
