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
      bg_w = self.background.sub_rect.w
      bg_h = self.background.sub_rect.h
      sprite_w = other_card.sprite_width
      sprite_h = other_card.sprite_height

      other_card.pos = self.pos

      if bg_w > sprite_w && bg_h > sprite_h
        w = bg_w - sprite_w
        h = bg_h - sprite_h

        other_card.pos += [w/2, h/2]
      end

      cards << other_card
    end

    # Sets position of the pile. Applies to
    # the cards in the pile and background both.
    def pos=(pos)
      background.pos = *pos
      cards.each { |card| card.pos = *pos }
    end

    # Returns true if the given card is the last
    # card in the pile Otherwise, returns false.
    def last_card?(card)
      card == cards.last
    end

    # Draws pile in the window.
    def draw_on(win)
      win.draw(background)
      cards.each { |card| card.draw_on(win) }
    end

    # Returns true or card, if there was clicked background or card
    # in the pile, respectively. Otherwise returns false or nil.
    def hit?(mouse_pos)
      background.to_rect.contain?(mouse_pos) or
      cards.find { |card| card.hit?(mouse_pos) }
    end

    # If the pile is empty, returns the result of collision detection
    # of the other_card and background of the pile. If the pile isn't
    # empty, tries to find a card, which overlaps other_card.
    def overlaps?(other_card)
      if cards.empty?
        background.to_rect.collide?(other_card)
      else
        cards.find { |card| card.face_up? and card.overlaps?(other_card) }
      end
    end

    def_delegators :@cards, :size, :empty?, :delete
    def_delegator  :@cards, :delete, :remove
    def_delegators :@background, :pos, :x, :y
  end
end
