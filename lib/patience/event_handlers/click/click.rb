module Patience
  class EventHandler
    class Click
      attr_reader :info

      def initialize(mouse_pos, areas)
        @info = InformationCollector.new(mouse_pos, areas)
        @info.gather!
      end

      def card
        info.to_h[:card]
      end

      def stock?
        info.to_h[:area].instance_of? Stock
      end

      def waste?
        info.to_h[:area].instance_of? Waste
      end

      def tableau?
        info.to_h[:area].instance_of? Tableau
      end

      def foundation?
        info.to_h[:area].instance_of? Foundation
      end

    end
  end
end
