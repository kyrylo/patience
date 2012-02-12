module Patience
  ###
  # Patience::Pile is aimed to hold cards in the pile :surprise:.
  # Every pile has its own background sprite and set of cards.
  #   cards = [Card.new(1, 1), Card.new(1, 2), Card.new(1, 3)]
  #   random_pile = Pile.new(cards)
  #   random_pile.background = [10, 10]
  #
  class Pile
    extend Forwardable

    attr_accessor :cards, :background

    def initialize(cards=[])
      @cards = cards
      pile_background = 'patience/sprites/pile_background.png'
      @background = Ray::Sprite.new path_of(pile_background)
    end

    # Changes background sprite of the pile considering position of the old one.
    def background=(bg)
      bg.pos = @background.pos
      @background = bg
    end

    # Throws off 'num' quantity of cards and returns the array of them.
    def shuffle_off!(num)
      cards.slice!(0..num-1)
    end

    # Appends card to the pile considering position of that pile.
    def <<(other_card)
      other_card.pos = self.pos
      cards << other_card
    end

    # Sets position of the pile. Applies to
    # the cards in the pile and background both.
    def pos=(pos)
      background.pos = *pos
      cards.each { |card| card.pos = *pos }
    end

    # Returns true if the given number is index of the last
    # element of the array of cards. Otherwise, returns false.
    def last_card?(n)
      cards[n] == cards.last
    end

    # Draws pile in the window.
    def draw_on(win)
      win.draw(background)
      cards.each { |card| card.draw_on(win) }
    end

    # Returns true or card, if there was clicked background or card
    # in the pile, respectively. Otherwise returns false or nil.
    def hit?(mouse_pos)
      background.to_rect.contain?(mouse_pos) ||
      cards.find { |card| card.hit?(mouse_pos) }
    end

    def_delegators :@cards, :size, :empty?
    def_delegators :@background, :pos, :x, :y
  end
end
