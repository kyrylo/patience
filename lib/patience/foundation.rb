require_relative 'pile'
require_relative 'drawing'
require_relative 'pile_manager'

module Patience
  class Foundation < Pile
    include Drawing
    include PileManager

    def initialize(cards=[], piles=4)
      @piles = piles.times.map { |i| cards.shift(i+1) }.map { |p| Pile.new(p) }
      x = 251
      @piles.each { |pile| pile.background.pos = [x+=110, 23] }
    end

  end
end
