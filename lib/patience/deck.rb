module Patience
  class Deck
    attr_reader :cards

    def initialize
      @cards = []

      Card::RANKS.each.with_index do |r, rank|
        Card::SUITS.each.with_index(1) do |s, suit|
          @cards << Card.new(rank, suit)
        end
      end
    end

    def size
      @cards.size
    end

  end
end
