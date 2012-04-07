require_relative '../processable'

module Patience
  module EventHandler
    ###
    # Click represents a state of every click in the game. Processable module
    # endows Click with special abilities (the group of "detect" methods).
    # Every object of Click has the scenario parameter, which is an instance of
    # the Lambda. Thereby, an action, which should be performed on click, can be
    # executed lately and lazily (on demand). Scenario is nothing but a bunch
    # of certain actions, being performed on click.
    #   cursor.click = EventHandler::Click.new(mouse_pos, areas)
    #   cursor.click.card #=> Two of Hearts
    #   cursor.click.card.pos  #=> (0, 0)
    #   cursor.click.scenario.call # Perform some action on the card.
    #   cursor.click.card.pos #=> (20, 20)
    #
    class Click
      extend Forwardable

      include Processable

      attr_reader :cards, :offset, :scenario

      def initialize(mouse_pos, areas)
        @mouse_pos = mouse_pos
        @areas     = areas
        @area      = detect_area

        # If area has been detected, calculate other parameters too.
        if @area
          @pile  = detect_pile
          @cards = collect_cards # A clicked card and tail cards.
          @card  = cards.keys.first if @cards # The very clicked card.
          @card  = nil if animating_card? # Prevent clicking the moving card.

          # Offset for dragged card.
          @offset = pick_up(@card, mouse_pos) if @card && something?

          @scenario = -> { stock }
        end
      end

      protected

      # Finds an area of a card, which was clicked.
      def detect_area
        detect_in(@areas, :area) { |area| area.hit?(@mouse_pos) }
      end

      # Finds a pile of a card, which was clicked.
      def detect_pile
        detect_in(@areas, :pile) { |pile| pile.hit?(@mouse_pos) }
      end

      # Finds a card, which was clicked and tries to find
      # descending cards, in the pile (if there are any).
      def collect_cards
        card = detect_in(@areas, :card) { |card| card.hit?(@mouse_pos) }
        return card unless card

        n = @pile.size - @pile.cards.index(card)
        tail_cards = @pile.cards.last(n)
        Hash[*tail_cards.map { |card| [card, card.pos] }.flatten]
      end

      # Internal: Check, whether the clicked card is performing some animations.
      def animating_card?
        Effect.animations.any? do |anim|
          @card == anim.target && anim.running?
        end
      end

      # Adds a card from Stock to Waste, if Stock was clicked.
      def stock
        if stock?

          if pile.empty?
            return if @areas[:waste].cards.size == 1
            pile.background = Ray::Sprite.new image_path('pile_background')
            refill_stock
          else
            displace_to_waste if @card
          end

          if pile.empty?
            if @areas[:waste].cards.size == 1
              pile.background = Ray::Sprite.new image_path('fully_empty_stock')
            else
              pile.background = Ray::Sprite.new image_path('empty_stock')
            end
          end

        end
      end

      # Removes all cards from Stock and adds them to Waste.
      def refill_stock
        @areas[:waste].tap { |waste|
          waste.cards.reverse_each do |card|
            @areas[:stock].add_from(waste.piles.first, card)
          end
        }
      end

      # Adds clicked card from Stock to Waste.
      def displace_to_waste
        @areas[:waste].add_from(@pile, @card)
      end

    end
  end
end
