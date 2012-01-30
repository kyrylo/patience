module Patience
  ###
  # Patience::Cursor is a high-level class, which deals with all events
  # in the game. Cursor always knows current position of the mouse.
  # Example:
  #   cursor = Cursor.new
  #   always { @cursor.mouse_pos = mouse_pos }
  #   cursor.clicked_something? #=> false
  #   cursor.still_on_something? #=> false
  #
  class Cursor
    extend Forwardable

    attr_accessor :mouse_pos, :click, :drag

    # Refreshes click and drag by setting them to nil.
    # Example:
    #   cursor.click = EventHandler::Click.new(mouse_pos, areas)
    #   cursor.click.card #=> Some card
    #   cursor.drop
    #   cursor.click.card #=> NoMethodError
    #
    def drop
      @click, @drag = nil, nil
    end

    # Checks whether cursor clicked something. If so, also checks, if the cursor
    # is still in boundaries of that object at the time of mouse button release.
    # Returns true, if this is true. Otherwise, returns false.
    # Example:
    #   cursor.click = EventHandler::Click.new(mouse_pos, areas)
    #   cursor.clicked_something? #=> true
    #
    #   cursor.click = EventHandler::Click.new(mouse_pos, areas)
    #   mouse_pos = [100, 100]
    #   cursor.clicked_something? #=> false
    #
    def clicked_something?
      click.something? and still_on_something?
    end

    # Checks whether cursor is still over the clicked object by
    # asking card or pile, if the mouse_pos is within the pale of
    # them. Returns true, if this is true. Otherwise, returns false.
    # Example:
    #   cursor.still_on_something? #=> false
    #   card.sprite.pos = mouse_pos
    #   cursor.still_on_something? #=> true
    #
    def still_on_something?
      if carrying_card?
        card.hit?(mouse_pos)
      elsif pile
        pile.hit?(mouse_pos)
      else
       false
      end
    end

    # Returns true if cursor clicked some card and that card is avaliable
    # for dragging (e.g. its face is up). Otherwise, returns false.
    # Example:
    #   cursor.click = EventHandler::Click.new(mouse_pos, areas)
    #   cursor.click.card => Ace of Spades
    #   cursor.click.card.face_down? => true
    #   cursor.movable? #=> false
    #
    def movable?
      carrying_card? and draggable?
    end

    # Returns true if cursor clicked something different from
    # nothing. And by "something different" I mean any card.
    # Example:
    #   cursor.click = EventHandler::Click.new(mouse_pos, areas)
    #   cursor.click.card #=> Ace of Spades
    #   cursor.carrying_card? #=> true
    #
    def carrying_card?
      click and card
    end

    ##
    # Returns true if the clicked object is drawable. Otherwise,
    # returns false. In fact, this method exists only for readability.
    alias :drawable? :movable?

    def_delegators :@click, :card, :pile, :offset
    def_delegator  :@drag, :draggable?
  end
end
