module Patience
  class EventHandler
    ###
    # Patience::EventHandler::Click is a class, which represents the state of
    # every click in the game. The class uses DataCollector and DataProcessor
    # as helpers to find and process information received by clicks.
    # Example:
    #   cursor.click = EventHandler::Click.new(mouse_pos, areas)
    #   cursor.click.card #=> Two of Hearts
    #
    class Click
      extend Forwardable

      attr_reader :offset

      # Instantiates a Click object. Takes two arguments: mouse_pos,
      # current mouse position and areas, that should be tested for
      # whether something was clicked in them or not. Also, calculates
      # offset for dragging cards and creates exec Proc, which includes
      # code to be executed as a reaction on the click.
      # Example:
      #   cursor.click = EventHandler::Click.new(mouse_pos, areas)
      #   cursor.click.mouse_pos #=> (0, 0)
      #   cursor.click.offset #=> (0, 0)
      #
      def initialize(mouse_pos, areas)
        @mouse_pos = mouse_pos
        @areas = areas
        @processor = DataProcessor.new(mouse_pos, areas)
        @offset = pick_up unless nothing?
        @exec = stock || waste || tableau || foundation
      end

      # Executes exec Proc, which contains click scenario.
      # Example:
      #   cursor.click = EventHandler::Click.new(mouse_pos, areas)
      #   cursor.click.exec # Some action should happen on the table.
      #
      def exec
        @exec.call
      end

      protected

      # Returns click scenario for Stock as Proc object, if
      # something in Stock was clicked. If nothing, returns nil.
      # Example:
      #   # ... Somewhere around here:
      #   @exec = @processor.stock_scenario
      #   # ... And then, somewhere there:
      #   cursor.click = EventHandler::Click.new(mouse_pos, areas)
      #   cursor.exec # Executes scenario for Stock.
      #
      def stock
        @processor.stock_scenario if @processor.stock?
      end

      # Returns click scenario for Waste as Proc object, if
      # something in Waste was clicked. If nothing, returns nil.
      # Example:
      #   # ... Somewhere around here:
      #   @exec = @processor.waste_scenario
      #   # ... And then, somewhere there:
      #   cursor.click = EventHandler::Click.new(mouse_pos, areas)
      #   cursor.exec # Executes scenario for Waste.
      #
      def waste
        @processor.waste_scenario if @processor.waste?
      end

      # Returns click scenario for Tableau as Proc object, if
      # something in Tableau was clicked. If nothing, returns nil.
      # Example:
      #   # ... Somewhere around here:
      #   @exec = @processor.tableau_scenario
      #   # ... And then, somewhere there:
      #   cursor.click = EventHandler::Click.new(mouse_pos, areas)
      #   cursor.exec # Executes scenario for Tableau.
      #
      def tableau
        @processor.tableau_scenario if @processor.tableau?
      end

      # Returns click scenario for Foundation as Proc object, if
      # something in Foundation was clicked. If nothing, returns nil.
      # Example:
      #   # ... Somewhere around here:
      #   @exec = @processor.foundation_scenario
      #   # ... And then, somewhere there:
      #   cursor.click = EventHandler::Click.new(mouse_pos, areas)
      #   cursor.exec # Executes scenario for Foundation.
      #
      def foundation
        @processor.foundation_scenario if @processor.foundation?
      end

      def_delegators :@processor, :pick_up, :card, :pile, :nothing?, :something?
    end
  end
end
