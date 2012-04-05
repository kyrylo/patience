module Patience
  # Public: Cursor deals with all events in the game. Cursor always knows
  # current position of the mouse in the game.
  #
  # Examples
  #
  #   cursor = Cursor.new
  #   always { @cursor.mouse_pos = mouse_pos }
  #   cursor.clicked_something?
  #   #=> false
  #   cursor.still_on_something?
  #   #=> false
  class Cursor
    extend Forwardable

    # Public: Gets/Sets the position of the mouse in the window.
    attr_accessor :mouse_pos

    # Public: Gets/Sets the EventHandler::Click object.
    attr_accessor :click

    # Public: Gets/Sets the EventHandler::Drag object.
    attr_accessor :drag

    # Public: Gets/Sets the EventHandler::Drop object.
    attr_accessor :drop

    # Public: Execute scenario for the click event.
    #
    # Returns nothing.
    def click!
      @click.scenario.call
    end

    # Public: Call calculated scenario for the drop event and then
    # refresh click, drag and drop variables by setting them to nil.
    #
    # Returns nil.
    def drop!
      @drop.scenario.call
      @click, @drag, @drop = nil, nil, nil
    end

    # Public: Check whether the cursor clicked something. If so, also checks, if
    # the cursor is still in boundaries of that object at the time of mouse
    # button releasing.
    #
    # Returns true if the statement above is true or false otherwise.
    def clicked_something?
      click and click.something? and still_on_something?
    end

    # Public: Check whether the cursor is still over the clicked object by
    # asking card or pile, if the mouse_pos is within the pale of them.
    #
    # Returns true if the statement above is true or false otherwise.
    def still_on_something?
      if carrying_card?
        card.hit?(mouse_pos)
      elsif pile
        pile.hit?(mouse_pos)
      else
       false
      end
    end

    # Public: Check, whether the card can be moved from one place to another.
    #
    # Returns true if the cursor clicked some card and that card is avaliable
    # for dragging (e.g. its face is up) or false otherwise.
    def movable?
      carrying_card? and draggable?
    end

    # Public: Check, whether the cursor carries the card.
    #
    # Returns true if cursor clicked something different from nothing. And by
    # "something different" I mean any card. Otherwise, returns false.
    def carrying_card?
      click and card
    end

    # In fact, this method exists only for readability.
    alias :drawable? :movable?

    def_delegators :@click, :card, :pile, :offset, :cards
    def_delegator  :@drag, :draggable?
  end
end
