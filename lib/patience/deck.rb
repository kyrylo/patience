module Patience
  class Deck
    attr_reader :cards

    def initialize
      @cards = []
      suits  = 0..13
      ranks  = 0..4

      suits.each do |rank|
        ranks.each { |suit| @cards << Card.new(rank, suit) }
      end

    end

    def size
      @cards.size
    end

  end
end
