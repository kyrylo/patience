module Patience
  ###
  # Patience::Area provides area objects, that consist of piles. The goal of
  # this class is to assemble piles into a logical bundle with some common
  # methods, so they could be controlled via only one interface.
  class Area
    attr_reader :piles

    def initialize(cards=[], piles_num=1)
      @piles = []
      @cards = Pile.new(cards)
      piles_num.times { @piles << Pile.new }
    end

    # Sets the position of every pile in the area.
    def pos=(pos)
      piles.each { |pile| pile.pos = *pos }
    end

    # Draws area in the window.
    def draw_on(win)
      piles.each { |pile| pile.draw_on(win) }
    end

    # Finds all cards in every pile and returns array of these cards.
    def cards
      cards = @piles.inject([]) { |cards, pile| cards << pile.cards  }
      cards.flatten
    end

  end
end
