require_relative 'pile'

module Patience
  class Foundation < Pile

    def initialize(cards=[], piles=4)
      @piles = piles.times.map { |i| cards.shift(i+1) }.map { |p| Pile.new(p) }
      x = 251
      each_background { |bg| bg.pos = [x+=110, 23] }
    end

    # Iterate over each background in
    # Foundation, yielding it to the block.
    def each_background
      @piles.each { |pile| yield(pile.background) }
    end

  end
end
