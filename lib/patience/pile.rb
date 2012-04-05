module Patience
  # Public: Pile is aimed to hold cards in the pile :surprise:. Every pile has
  # its own background sprite and set of cards.
  #
  # Examples
  #
  #   cards = [Card.new(1, 1), Card.new(1, 2), Card.new(1, 3)]
  #   random_pile = Pile.new(cards)
  #   random_pile.background = [10, 10]
  class Pile
    extend Forwardable

    attr_accessor :cards, :background

    # Public: Create the pile of cards (or empty pile).
    #
    # cards - The Array of cards, that should be stored in the pile.
    #
    # Returns nothing.
    def initialize(cards=[])
      @cards = cards
      pile_background = 'patience/sprites/pile_background.png'
      @background = Ray::Sprite.new path_of(pile_background)
    end

    # Public: Change the background sprite of the pile considering position of
    # the old one.
    #
    # bg - The Ray::Sprite object, which is nothing but an image.
    #
    # Examples
    #
    #   pile.background = Ray::Sprite.new
    #
    # Returns nothing.
    def background=(bg)
      bg.pos = @background.pos
      @background = bg
    end

    # Public: Throw off some quantity of cards from the pile.
    #
    # num - The Integer, signifying the quantity of cards to be thrown.
    #
    # Examples
    #
    #   pile.throw_off(2)
    #   #=> [Ace of Spades, Ace of Hearts]
    #
    # Returns the Array of thrown cards.
    def shuffle_off!(num)
      cards.slice!(0..num-1)
    end

    # Public: Append the card to the pile considering position of that pile.
    #
    # other_card - The Card to be appended to the pile.
    #
    # Examples
    #
    #   pile << Card.new(1, 1)
    #   #=> [Ace of Hearts]
    #   pile << Card.new(1, 3)
    #   #=> [Ace of Hearts, Ace of Spades]
    #
    # Returns the Array of cards in the pile.
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

    # Public: Set the position of the pile. Applies both to the cards in the
    # pile and the background of the pile.
    #
    # pos - The Ray::Vector2 coordinate or the Array of X and Y coordinates.
    #
    # Examples
    #
    #   pile.pos = [100, 100]
    #   #=> [100, 100]
    #
    # Returns either the Ray::Vector2 coordinate or the Array.
    def pos=(pos)
      background.pos = *pos
      cards.each { |card| card.pos = *pos }
    end

    # Public: Check, whether the given card is the last card in the pile.
    #
    # Returns true if the given card is the last card in the pile or false
    # otherwise.
    def last_card?(card)
      card == cards.last
    end

    # Public: Draw the pile in the window.
    #
    # win - The Ray::Window object, which handles drawing.
    #
    # Returns nothing.
    def draw_on(win)
      win.draw(background)
      cards.each { |card| card.draw_on(win) }
    end

    # Public: Check, whether the pile received a click or not.
    #
    # mouse_pos - The Ray::Vector2 coordinate or the Array of X and Y
    #             coordinates.
    #
    # Returns true or card if the background was clicked or returns the card in
    # the pile, respectively. Otherwise returns false or nil.
    def hit?(mouse_pos)
      background.to_rect.contain?(mouse_pos) or
      cards.find { |card| card.hit?(mouse_pos) }
    end

    # Public: Check, whether the pile overlaps (collides) the given card,
    # by comparing the position of the card and the pile.
    #
    # other_card - The Card, which should be checked, if it's colliding with the
    #              pile.
    #
    # Returns the result of collision detection of the other_card and the
    # background of the pile, if the pile is empty. If the pile isn't empty,
    # tries to find a card, which overlaps other_card.
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
