module Patience
  module PileManager
    attr_reader :piles

    # Finds all cards in every pile and returns array of these cards.
    def cards
      cards = @piles.inject([]) { |cards, pile| cards << pile.cards  }
      cards.flatten
    end

  end
end
