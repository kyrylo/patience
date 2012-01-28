module Patience
  ###
  # Patience::Pile is aimed to hold cards in the pile :surprise:.
  # Every pile has its own background sprite and set of cards.
  # Example:
  #   cards = [Card.new(1, 1), Card.new(1, 2), Card.new(1, 3)]
  #   random_pile = Pile.new(cards)
  #   random_pile.background = [10, 10]
  #
  # Methods to reconsider: #last_card?
  class Pile
    extend Forwardable

    attr_accessor :cards, :background

    # Instantiates Pile object. Accepts an array of cards. It would
    # create an empty Pile, if it had not been given any arguments.
    # Example:
    #   pile = Pile.new
    #   pile.cards #=> []
    #   mypile = Pile.new(Card.new(1, 1))
    #   mypile.cards #=> [Two of Hearts]
    #
    def initialize(cards=[])
      @cards = cards
      pile_background = 'patience/sprites/pile_background.png'
      @background = Ray::Sprite.new path_of(pile_background)
    end

    # Changes background sprite of the pile considering position of the old one.
    # Example:
    #   pile = Pile.new(1, 1)
    #   pile.background.pos = [10, 10]
    #   pile.background.pos #=> (10, 10)
    #   pile.background = Ray::Sprite.new(path_to_sprite)
    #   pile.background.pos #=> (10, 10)
    #
    def background=(bg)
      bg.pos = @background.pos
      @background = bg
    end

    # Throws off 'num' quantity of cards and returns the array of them.
    # Example:
    #   cards.size #=> 4
    #   cards.shuffle_off!(2) #=> [Ace of Spades, Two of Hearts]
    #   cards.size #=> 2
    #
    def shuffle_off!(num)
      cards.slice!(0..num-1)
    end

    # Appends card to the pile considering position of that pile.
    # Example:
    #   pile1 = Pile.new([Card.new(1, 1)])
    #   pile1.size #=> 1
    #   pile2 = Pile.new
    #   pile2 << pile1[0]
    #   pile1.size #=> 0
    #   pile2.cards #=> [Two of Hearts]
    #
    def <<(other_card)
      other_card.sprite.pos = self.pos
      cards << other_card
    end

    # Sets position of the pile. Applies to
    # the cards in the pile and background both.
    # Example:
    #   pile = Pile.new
    #   pile.pos = [10, 10]
    #   pile.background.pos #=> (10, 10)
    #
    def pos=(pos)
      background.pos = *pos
      cards.each { |card| card.sprite.pos = *pos }
    end

    # (?)
    # Returns true if the given number is index of the last
    # element of the array of cards. Otherwise, returns false.
    # Example:
    #   pile = Pile.new([Card.new(1, 1)])
    #   pile.last_card?(0) #=> true
    #
    def last_card?(n)
      cards[n] == cards.last
    end

    # Draws pile in the window.
    # Example:
    #   pile = Pile.new
    #   pile.draw_on(win)
    def draw_on(win)
      win.draw(background)
      cards.each { |card| card.draw_on(win) }
    end

    def_delegators :@cards, :size, :empty?
    def_delegators :@background, :pos, :x, :y, :to_rect
    def_delegator  :"@background.to_rect", :contain?, :hit?
  end
end
