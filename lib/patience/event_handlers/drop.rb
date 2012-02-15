require_relative '../processable'

module Patience
  class EventHandler
    # Drop's objects handles dropping of the cards. It means, that these
    # objects decide, what to do with dropped card. For example, they can return
    # a dropped card to its initial position, cancelling the work of drag event.
    #   cursor.drop = EventHandler::Drop.new(cursor, areas)
    #   # Execute scenario for the drop event,
    #   # which calculates by analasing input data.
    #   cursor.drop.scenario.call
    #
    class Drop

      include Processable

      attr_reader :scenario

      def initialize(cursor, areas)
        @dropped_card = cursor.card
        @dropped_card_init_pos = cursor.card_init_pos
        @mouse_pos = cursor.mouse_pos
        @pile = cursor.pile
        @areas = areas
        @area = find_area_beneath
        @card_beneath = find_card_beneath
        @pile_beneath = find_pile_beneath
        @scenario = -> { put_in or call_off }
      end

      protected

      # Finds operative card and returns area, which that
      # card belongs to. If cannot find the card, returns nil.
      def find_area_beneath
        select_in(@areas, :area) do |area|
          find_card_in({:area => area}) { |card| operative?(card) }
        end
      end

      # Returns the pile, onto which the area's been
      # dropped. If cannot find the area, returns nil.
      def find_pile_beneath
        select_in(@areas, :pile) { |pile| pile.cards.include?(@card_beneath) }
      end

      # Returns the operative card (which overlaps another
      # card). If cannot find the card, returns nil.
      def find_card_beneath
        select_in(@areas, :card) { |card| operative?(card) }
      end

      # Returns true, if the card meets the requirements
      # of certain conditions. Otherwise, returns false.
      def operative?(card)
        card.overlaps?(@dropped_card) && !waste? && card.face_up? &&
        meets_rank_conditions?(card) && meets_suit_conditions?(card)
      end

      # Returns true, if the rank of card is higher by one that
      # the rank of the dropped card. Otherwise, returns false.
      def meets_rank_conditions?(card)
        card.rank.higher_by_one_than?(@dropped_card.rank)
      end

      # Returns true, if the suit of card differs from
      # the suit of dropped card. Otherwise, returns false.
      def meets_suit_conditions?(card)
        card.suit.different_color?(@dropped_card.suit)
      end

      # Sets the position of dropped card to its initial one.
      def call_off
        @dropped_card.pos = @dropped_card_init_pos unless @card_beneath
      end

      # Adds dropped card to the pile.
      def put_in
        if @card_beneath
          @pile_beneath << exempt(@dropped_card)
          @dropped_card.pos = @pile_beneath.cards[-2].pos + [0, 20]
        end
      end

    end
  end
end
