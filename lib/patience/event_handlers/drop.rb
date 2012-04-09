require_relative '../processable'

module Patience
  module EventHandler
    # Drop's objects handles dropping of the cards. It means, that these
    # objects decide, what to do with dropped card. For example, they can return
    # a dropped card to its initial position, cancelling the work of drag event.
    #   cursor.drop = EventHandler::Drop.new(click, areas)
    #   # Execute scenario for the drop event,
    #   # which calculates dynamically.
    #   cursor.drop.scenario.call
    #
    class Drop
      include Ray::Helper
      include Processable

      attr_reader :scenario

      def initialize(click, areas)
        @cards        = click.cards
        @areas        = areas
        @pile         = click.pile
        @card_to_drop = click.card

        @card_beneath = find_card_beneath
        @pile_beneath = find_pile_beneath
        @area         = find_area_beneath

        @scenario = -> {
          if tableau?
            put_in_tableau
          elsif foundation?
            put_in_foundation
          else
            call_off
          end
        }
      end

      protected

      # Finds an area beneath the dropped card.
      def find_area_beneath
        detect_in(@areas, :area) { |area| area.piles.include?(@pile_beneath) }
      end

      # Finds a pile beneath the dropped card.
      def find_pile_beneath
        # Find out, if dropped card is a king or an ace.
        king_or_ace = @card_to_drop.rank.king? || @card_to_drop.rank.ace?
        detect_in(@areas, :pile) do |pile|
          # If dropped card is a king or an ace, don't
          # check, whether a pile includes card beneath.
          pile != @pile && pile.overlaps?(@card_to_drop) &&
          (if king_or_ace
             pile.empty? || (@card_beneath && @card_beneath.rank.queen?)
           else
             pile.cards.include?(@card_beneath)
           end)
        end
      end

      # Finds a card beneath the dropped card.
      def find_card_beneath
        all_tail_cards = @areas.values.flat_map do |area|
          area.piles.map { |pile| pile.cards.last }
        end.compact

        # Iterate only over tail cards.
        all_tail_cards.find do |card|
          area = detect_in(@areas, :area) { |area| area.cards.include?(card)}
          card.face_up? && card.overlaps?(@card_to_drop) &&
          (case area
            when Tableau then tableau_conditions?(card)
            when Foundation then foundation_conditions?(card)
          end)
        end
      end

      # Returns true, if card's rank is higher by 1 than the rank of
      # the card which is dropped and the card's suit has different color.
      def tableau_conditions?(card)
        card.rank.higher_by_one_than?(@card_to_drop.rank) &&
        card.suit.different_color?(@card_to_drop.suit)
      end

      # Returns true, if card's rank is lower by 1 than the rank of the
      # card, which is dropped and the card's suit must be the same color.
      def foundation_conditions?(card)
        @card_to_drop.rank.higher_by_one_than?(card.rank) &&
        card.suit == @card_to_drop.suit
      end

      # Removes card from its pile and adds to the pile beneath.
      def add_to_pile_beneath(card)
        @pile_beneath << @pile.remove(card)
      end

      # Sets the position of a dropped card to its initial location.
      def call_off
        @cards.each do |card, init_pos|
          Animation.call_off(card, init_pos)
        end
      end

      # Returns true, if dropped card meets
      # requirements for dropping into Tableau.
      def can_put_in_tableau?
        (@pile_beneath.empty? && @card_to_drop.rank.king?) ||
        (@card_beneath && @card_to_drop.rank.not.ace? &&
        @pile_beneath.last_card?(@card_beneath) &&
        tableau_conditions?(@card_beneath))
      end

      # Returns true, if dropped card meets
      # requirements for dropping into Foundation.
      def can_put_in_foundation?
        (@pile_beneath.empty? && @card_to_drop.rank.ace?) ||
        (@card_beneath && foundation_conditions?(@card_beneath))
      end

      # Adds dropped card to one of Tableau's piles, if it's
      # possible. If not, calls off card to it's initital position.
      def put_in_tableau
        if can_put_in_tableau?
          @cards.keys.each_with_index do |card, i|
            add_to_pile_beneath(card)
            if @pile_beneath.size == 1 # It was empty one line before.
              card.pos = @pile_beneath.pos + [0, i*19]
            else
              card.pos = @pile_beneath.cards[-2].pos + [0, 19]
            end
            @pile.cards.last.face_up unless @pile.empty?
          end
        else
          call_off
        end
      end

      # Adds dropped card to one of Foundation's piles, if it's
      # possible. If not, calls off card to it's initital position.
      def put_in_foundation
        if can_put_in_foundation?
          add_to_pile_beneath(@card_to_drop)
          @pile.cards.last.face_up unless @pile.empty?
        else
          call_off
        end
      end

    end
  end
end
