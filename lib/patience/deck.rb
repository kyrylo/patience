require_relative 'pile'

module Patience
  # Public: Creates the deck with playing cards.
  class Deck < Pile

    # Public: Create the play deck object, which contains 52 cards (just like a
    # real world deck!).
    #
    # Examples
    #
    #   deck = Deck.new(cards_ary)
    #   deck.cards.size
    #   #=> 52
    #
    # Returns nothing.
    def initialize
      @cards = []

      Card::Rank.descendants.size.times do |r|
        Card::Suit.descendants.size.times { |s| @cards << Card.new(r+1, s+1) }
      end
    end

  end
end
