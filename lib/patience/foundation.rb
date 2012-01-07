require_relative 'pile'

module Patience
  class Foundation < Pile
    attr_reader :piles

    def initialize(cards=[], piles=4)
      @piles = piles.times.map { |i| cards.shift(i+1) }.map { |p| Pile.new(p) }
      x = 251
      @piles.each { |pile| pile.background.pos = [x+=110, 23] }
    end

  end
end
