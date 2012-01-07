require_relative 'pile'

module Patience
  class Stock < Pile

    def initialize(cards)
      super(cards.each(&:face_down))
      self.pos = [31, 23]
    end

  end
end
