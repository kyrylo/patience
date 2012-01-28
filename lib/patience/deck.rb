require_relative 'pile'

module Patience
  ###
  # Patience::Deck creates a play deck object, which
  # contains 52 cards (just like a real world deck!).
  # Example:
  #   deck = Deck.new(cards) # Just imagine, that we've already created those!
  #   deck.cards.size #=> 52
  #
  class Deck < Pile

    # Creates a play deck. That's it!
    def initialize
      @cards = []

      Card::Rank.descendants.size.times do |r|
        Card::Suit.descendants.size.times { |s| @cards << Card.new(r+1, s+1) }
      end
    end

  end
end
