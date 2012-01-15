require_relative 'pile'
require_relative 'card_helper'

module Patience
  class Waste < Pile
    include CardHelper

    def initialize(cards=[])
      super(cards)
      self.pos = [141, 23]
    end

  end
end
