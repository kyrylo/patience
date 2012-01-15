require_relative 'pile'
require_relative 'drawing'

module Patience
  class Waste < Pile
    include Drawing

    def initialize(cards=[])
      super(cards)
      self.pos = [141, 23]
    end

  end
end
