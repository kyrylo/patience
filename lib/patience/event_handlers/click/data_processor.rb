module Patience
  class EventHandler
    class Click
      class DataProcessor
        attr_reader :data

        def initialize(mouse_pos, areas)
          @mouse_pos = mouse_pos
          @areas = areas
          @data = DataCollector.new(mouse_pos, areas)
          @data.gather!
        end

        def exempt(card)
          pile.cards.delete(card)
        end

        def nothing?
          data.to_a.compact.size.zero?
        end

        def offset
          data.to_h[:card].sprite.pos - mouse_pos
        end

        def pile
          data.to_h[:pile]
        end

        def card
          data.to_h[:card]
        end

        def stock?
          data.to_h[:area].instance_of? Stock
        end

        def stock_scenario
          Proc.new do
            if pile.empty?
              @areas[:waste].cards.each { |card|
                card.face_down
                @areas[:stock].piles.first << card
              }
            else
              card.face_up
              @areas[:waste].piles.first << exempt(card)
            end

            if pile.empty?
              empty_stock = 'patience/sprites/empty_stock.png'
              pile.background = Ray::Sprite.new path_of(empty_stock)
            end
          end
        end

        def waste?
          data.to_h[:area].instance_of? Waste
        end

        def waste_scenario
          Proc.new do
          end
        end

        def tableau?
          data.to_h[:area].instance_of? Tableau
        end

        def tableau_scenario
          Proc.new do
          end
        end

        def foundation?
          data.to_h[:area].instance_of? Foundation
        end

        def foundation_scenario
          Proc.new do
          end
        end

      end
    end
  end
end
