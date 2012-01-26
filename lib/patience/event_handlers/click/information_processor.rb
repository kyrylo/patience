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

        def stock_scenario
          Proc.new do
            empty_stock = 'patience/sprites/empty_stock.png'
            if pile.size == 1
              pile.background = Ray::Sprite.new path_of(empty_stock)
            end
            card.face_up
            @areas[:waste].piles.first << exempt(card)
          end
        end

        def waste?
          info.to_h[:area].instance_of? Waste
        end

        def waste_scenario
          Proc.new do
          end
        end

        def tableau?
          info.to_h[:area].instance_of? Tableau
        end

        def tableau_scenario
          Proc.new do
          end
        end

        def foundation?
          info.to_h[:area].instance_of? Foundation
        end

        def foundation_scenario
          Proc.new do
          end
        end

      end
    end
  end
end
