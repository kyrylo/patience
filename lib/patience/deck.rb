module Patience
  ###
  # Patience::Deck allows managing stack of cards. Every initial card deck
  # contains 52 cards (just like in real world).
  class Deck < Pile
    attr_reader :cards

    def initialize
      @cards = []

      Card::Rank.descendants.size.times do |r|
        Card::Suit.descendants.size.times { |s| @cards << Card.new(r+1, s+1) }
      end
    end

  end
end
