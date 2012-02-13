require_relative '../processable'

module Patience
  class EventHandler
    # Drop's objects handles dropping of the cards. It means, that these
    # objects decide, what to do with dropped card. For example, they can return
    # a dropped card to its initial position, cancelling the work of drag event.
    #   cursor.drop = EventHandler::Drop.new(card, card_init_pos,
    #                                         mouse_pos, areas)
    #   # Execute scenario for the drop event,
    #   # which calculates by analasing input data.
    #   cursor.drop.scenario.call
    #
    class Drop

      include Processable

      attr_reader :scenario

      def initialize(dropped_card, dropped_init_pos, mouse_pos, areas)
        @dropped_card = dropped_card
        @dropped_card_init_pos = dropped_init_pos
        @mouse_pos = mouse_pos
        @areas = areas
        @card_beneath = find_card_beneath
        @scenario = -> { call_off unless @card_beneath }
      end

      protected

      # Returns the operative card (which overlaps another
      # card). If cannot find a card, returns nil.
      def find_card_beneath
        select_in(@areas, :card) { |card| operative?(card) }
      end

      # Returns true, if the card meets the requirements of certain conditions:
      # the card should overlap another card, the card should be turned to its
      # face and the card isn't a dropped card. Otherwise, returns false.
      def operative?(card)
        card.overlaps?(@dropped_card) && card.face_up? && card != @dropped_card
      end

      # Sets the position of dropped card to its initial one.
      def call_off
        @dropped_card.pos = @dropped_card_init_pos
      end

    end
  end
end
