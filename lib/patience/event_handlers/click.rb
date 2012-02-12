require_relative '../processable'

module Patience
  class EventHandler
    ###
    # Click represents a state of every click in the game. Processable module
    # endows Click with special abilities (the group of "find" methods). Every
    # object of Click has the scenario parameter, which is an instance of the
    # Lambda. Thereby, an action, which should be performed on click, can be
    # executed lately and lazily (on demand). Scenario is nothing but a bunch of
    # certain actions, being performed on click.
    # Example:
    #   cursor.click = EventHandler::Click.new(mouse_pos, areas)
    #   cursor.click.card #=> Two of Hearts
    #   cursor.click.card.pos  #=> (0, 0)
    #   cursor.click.scenario.call # Perform some action on the card.
    #   cursor.click.card.pos #=> (20, 20)
    #
    class Click
      extend Forwardable

      include Processable

      attr_reader :card_init_pos, :offset, :scenario

      def initialize(mouse_pos, areas)
        @mouse_pos = mouse_pos
        @areas = areas
        @area = select_area
        # If area has been detected, calculate other parameters too.
        if @area
          @pile = select_pile
          @card = select_card
          @card_init_pos = @card.pos if @card
          # Offset for dragged card.
          @offset = pick_up(card, mouse_pos) unless nothing?
          @scenario = -> { (stock if stock?) or (foundation if foundation?) or
                         (tableau or tableau?) or (waste? if waste?) }
        end
      end

      protected

      def select_area
        select_in(@areas, :area) { |area| area.hit?(@mouse_pos) }
      end

      def select_pile
        select_in(@areas, :pile) { |pile| pile.hit?(@mouse_pos) }
      end

      def select_card
        select_in(@areas, :card) { |card| card.hit?(@mouse_pos) }
      end

      # Executes scenario for the click on Stock.
      def stock
        stock = @areas[:stock]
        waste = @areas[:waste]

        if pile.empty?
          pile_background = 'patience/sprites/pile_background.png'
          pile.background = Ray::Sprite.new path_of(pile_background)
        end

        if pile.empty?
          waste.cards.each { |card| card.face_down and stock.piles[0] << card }
        else
          card.face_up and waste.piles[0] << exempt(card)
        end

        if pile.empty?
          empty_stock = 'patience/sprites/empty_stock.png'
          pile.background = Ray::Sprite.new path_of(empty_stock)
        end
      end

      # Executes scenario for the click on Waste.
      def waste
      end

      # Executes scenario for the click on Tableau.
      def tableau
      end

      # Executes scenario for the click on Foundation.
      def foundation
      end

    end
  end
end
