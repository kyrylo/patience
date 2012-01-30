module Patience
  class EventHandler
    ###
    # Patience::EventHandler::Drag provides drag objects,
    # that serves for moving cards in the window.
    # Example:
    #   cursor.drag  = EventHandler::Drag.new(cursor.card, cursor.offset)
    #   cursor.drag.move(mouse_pos) if cursor.movable?
    #
    class Drag

      # Instantiates drag object. Takes two arguments: the card,
      # which should be dragged and the offset, which is subtraction
      # between and positon of the card mouse position.
      # Example:
      #   cursor.drag  = EventHandler::Drag.new(Card.new(1, 1), cursor.offset)
      #
      def initialize(card, offset)
        @card = card
        @offset = offset
      end

      # Changes position of the card's sprite, considering the offset.
      # Example:
      #   cursor.card.sprite.pos #=> (0, 0)
      #   cursor.drag.move(mouse_pos)
      #   cursor.card.sprite.pos #=> (120, 120)
      #
      def move(mouse_pos)
        @card.sprite.pos = mouse_pos + @offset
      end

      # Returns true if there is a card to drag and this card
      # is turned to its face. Otherwise, returns false.
      # Example:
      #   cursor.drag.draggable? #=> true
      #
      def draggable?
        @card.not.nil? and @card.face_up?
      end

    end
  end
end
