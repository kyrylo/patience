module Patience
  ###
  # Patience::Deck allows managing stack of cards. Every initial card deck
  # contains 52 cards (just like in real world).
  class Deck < Pile
    attr_reader :cards

    def initialize
      @cards = []

      Card::RANKS.each.with_index do |r, rank|
        Card::SUITS.each.with_index(1) do |s, suit|
          @cards << Card.new(rank, suit)
        end
      end
    end

  end
end
