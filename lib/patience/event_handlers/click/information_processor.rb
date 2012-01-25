module Patience
  class EventHandler
    class Click
      class InformationProcessor
        attr_reader :info

        def initialize(mouse_pos, areas)
          @mouse_pos = mouse_pos
          @areas = areas
          @info = InformationCollector.new(mouse_pos, areas)
          @info.gather!
        end

        def exempt(card)
          pile.cards.delete(card)
        end

        def nothing?
          info.to_a.compact.size.zero?
        end

        def offset
          info.to_h[:card].sprite.pos - mouse_pos
        end

        def pile
          info.to_h[:pile]
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
end
