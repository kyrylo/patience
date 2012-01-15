require_relative 'pile'
require_relative 'drawing'

module Patience
  class Stock < Pile
    include Drawing

    def initialize(cards)
      super(cards.each(&:face_down))
      self.pos = [31, 23]
    end

  end
end
