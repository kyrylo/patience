require_relative 'pile'
require_relative 'card_helper'

module Patience
  class Stock < Pile
    include CardHelper

    def initialize(cards)
      super(cards.each(&:face_down))
      self.pos = [31, 23]
    end

  end
end
