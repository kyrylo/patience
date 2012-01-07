require_relative 'pile'

module Patience
  class Waste < Pile

    def initialize(cards=[])
      super(cards)
      self.pos = [141, 23]
    end

  end
end
