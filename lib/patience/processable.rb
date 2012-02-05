module Patience
  ###
  # Processable
  module Processable

      class << self
        attr_writer :areas, :mouse_pos
      end

      attr_reader :area, :pile, :card

      # Returns the area, which is being clicked if
      # there has been provided areas and mouse position.
      def find_area
        if @areas && @mouse_pos
          @areas.values.find { |area| area.hit?(@mouse_pos) }
        end
      end

      # Returns the pile, which is being clicked if area's been found.
      def find_pile
        find_area.piles.find { |pile| pile.hit?(@mouse_pos) } if find_area
      end

      # Returns the card, which is being clicked if pile's been found.
      def find_card
        if find_pile
          find_pile.cards.reverse.find { |card| card.hit?(@mouse_pos) }
        end
      end

      # Returns the array, containing gathered hit elements.
      def to_a
        [area, pile, card]
      end

      # Returns the hash, containing gathered hit elements.
      def to_h
        { :area => area, :pile => pile, :card => card }
      end

      # Returns true, if there hasn't been found
      # something. Otherwise, returns false.
      def nothing?
        to_a.compact.size.zero?
      end

      # Returns true, if there's been found something.
      # Otherwise, returns false. Opposite of #nothing?.
      def something?
        not nothing?
      end

      # Returns subtraction between card and mouse position at the moment
      # of click, only if cursor clicked the card. Otherwise, returns nil.
      def pick_up
        card.sprite.pos - @mouse_pos if card
      end

      # Returns true, if the clicked area is Stock. Otherwise, returns false.
      def stock?
        area.instance_of? Stock
      end

      # Returns true, if the clicked area is Waste. Otherwise, returns false.
      def waste?
        area.instance_of? Waste
      end

      # Returns true, if the clicked area is Tableau. Otherwise, returns false.
      def tableau?
        area.instance_of? Tableau
      end

      # Returns true, if the clicked area is
      # Foundation. Otherwise, returns false.
      def foundation?
        area.instance_of? Foundation
      end

      # Deletes card from the pile and returns it. It is used in scenarios.
      def exempt(card)
        pile.cards.delete(card)
      end

      protected :find_area, :find_pile, :find_card
  end
end
