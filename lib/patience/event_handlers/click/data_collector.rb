module Patience
  class EventHandler
    class Click
      class DataCollector
        attr_reader :mouse_pos, :area, :pile, :card

        def initialize(mouse_pos, areas)
          @areas     = areas
          @mouse_pos = mouse_pos
          @area, @pile, @card = nil, nil, nil
        end

        def gather!
          find_all || find_pile if @pile.nil?
        end

        def find_all
          @area = @areas.values.to_a.find do |area|
            @pile = area.piles.find { |pile|
              @card = pile.cards.find { |card| card.hit?(mouse_pos) }
            }
          end
        end

        def find_pile
          @area = @areas.values.to_a.find { |area|
            @pile = area.piles.find { |pile| pile.hit?(mouse_pos) }
          }
        end

        def to_h
          { :area => area, :pile => pile, :card => card }
        end

        def to_a
          [area, pile, card]
        end

        def to_s
          "Click on card #{card}, in pile #{pile}, in the region of #{area}"
        end

      end
    end
  end
end
