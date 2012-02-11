require_relative '../processable'

module Patience
  class EventHandler
    ###
    # Patience::EventHandler::Drag provides drag objects,
    # that serves for moving cards in the window.
    #   cursor.drag  = EventHandler::Drag.new(cursor.card, cursor.offset)
    #   cursor.drag.move(mouse_pos) if cursor.movable?
    #
    class Drag
      include Processable

      def initialize(card, offset)
        @card = card
        @offset = offset
      end

      # Changes position of the card's sprite, considering the offset.
      def move(mouse_pos)
        @card.sprite.pos = mouse_pos + @offset
      end

      # Returns true if there is a card to drag and this card
      # is turned to its face. Otherwise, returns false.
      def draggable?
        @card.not.nil? and @card.face_up?
      end

    end
  end
end
