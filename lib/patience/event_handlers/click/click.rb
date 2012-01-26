module Patience
  class EventHandler
    class Click

      def initialize(mouse_pos, areas)
        @mouse_pos = mouse_pos
        @areas = areas
        @processor = InformationProcessor.new(mouse_pos, areas)
        @exec = stock || waste || tableau || foundation
      end

      def exec
        @exec.call
      end

      def card
        @processor.card
      end

      def drag
        @processor.card.sprite.pos = mouse_pos + @processor.offset
      end

      def nothing?
        @processor.nothing?
      end

      protected

      def stock
        @processor.stock_scenario if @processor.stock?
      end

      def waste
        @processor.waste_scenario if @processor.waste?
      end

      def tableau
        @processor.tableau_scenario if @processor.tableau?
      end

      def foundation
        @processor.foundation_scenario if @processor.foundation?
      end

    end
  end
end
