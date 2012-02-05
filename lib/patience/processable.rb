module Patience
  ###
  # Processable
  module Processable

      class << self
        attr_writer :areas, :mouse_pos
      end

      # Returns the area, which is being clicked.
      def find_area
        @areas.values.find { |area| area.hit?(@mouse_pos) }
      end

      # Returns the pile, which is being clicked.
      def find_pile
        find_area.piles.find { |pile| pile.hit?(@mouse_pos) }
      end

      # Returns the card, which is being clicked.
      def find_card
        find_pile.cards.reverse.find { |card| card.hit?(@mouse_pos) }
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

      # Returns area if there is any. Otherwise, returns nil.
      def area
        to_h[:area]
      end

      # Returns pile if there is any. Otherwise, returns nil.
      def pile
        to_h[:pile]
      end

      # Returns card if there is any. Otherwise, returns nil.
      def card
        to_h[:card]
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
