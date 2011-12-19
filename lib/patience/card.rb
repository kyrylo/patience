module Patience
  class Card
    extend Forwardable
    def_delegators :@sprite, :pos, :x, :y

    attr_reader :rank, :suit, :sprite

    def initialize(rank, suit)
      @rank   = rank
      @suit   = suit
      @sprite = Ray::Sprite.new('sprites/card_deck.png')

      @sprite.sheet_size = [13, 5]
      @sprite.sheet_pos = [rank, suit]
    end

    def pick_up(mouse_pos)
      @offset = @sprite.pos - mouse_pos
    end

    def drag(mouse_pos)
      @sprite.pos = mouse_pos + @offset
    end

    def received_click?(mouse_pos)
      @sprite.to_rect.contain?(mouse_pos)
    end

  end
end
























