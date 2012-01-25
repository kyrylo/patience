module Patience
  class EventHandler
    class Click

      def initialize(mouse_pos, areas)
        @mouse_pos = mouse_pos
        @areas = areas
        @processor = InformationProcessor.new(mouse_pos, areas)

        if @processor.stock?
          @exec = Proc.new do
            if @processor.pile.size == 1
              @processor.pile.background = Ray::Sprite.new path_of "patience/sprites/empty_stock.png"
            end
            @processor.card.face_up
            @areas[:waste].piles.first << @processor.exempt(@processor.card)
          end
        elsif @processor.waste?
          @exec = Proc.new {}
        elsif @processor.tableau?
          @exec = Proc.new {}
        elsif @processor.foundation?
          @exec = Proc.new {}
        end
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

    end
  end
end
