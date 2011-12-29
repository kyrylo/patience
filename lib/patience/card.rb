module Patience
  class Card
    extend Forwardable
    def_delegators :@sprite, :pos, :x, :y

    attr_reader :rank, :suit, :sprite

    SUITS = [:hearts, :diamonds, :spades, :clubs]
    RANKS = [2, 3, 4, 5 ,6 ,7 ,8 ,9, 10, :jack, :queen, :king, :ace]

    def initialize(rank, suit)
      @rank   = rank
      @suit   = suit
      @sprite = Ray::Sprite.new path_of('patience/sprites/card_deck.png')
      @sprite.sheet_size = [13, 5]
      @sprite.sheet_pos = [rank, suit]
    end

    def to_s
      "#{RANKS[@rank]} of #{SUITS[@suit-1]}"
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
























