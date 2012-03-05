require_relative '../processable'

module Patience
  class EventHandler
    ###
    # Patience::EventHandler::Drag provides drag objects,
    # that serves for moving cards in the window.
    #   areas = { :tableau => Tableau.new }
    #   cursor.drag = EventHandler::Drag.new(cursor)
    #   cursor.drag.move(mouse_pos) if cursor.movable?
    #
    class Drag
      include Processable

      def initialize(cursor)
        @card = cursor.card
        @tail_cards = cursor.cards
        @offset = cursor.offset
      end

      # Changes position of the card's sprite, considering the offset.
      def move(mouse_pos)
        @tail_cards.keys.each_with_index do |card, i|
          card.pos = mouse_pos + @offset + [0, i*20]
        end
      end

      # Returns true if there is a card to drag and this card
      # is turned to its face. Otherwise, returns false.
      def draggable?
        card.not.nil? and card.face_up?
      end

    end
  end
end
