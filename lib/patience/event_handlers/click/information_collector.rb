module Patience
  class EventHandler
    class Click
      class InformationCollector
        attr_reader :mouse_pos, :area, :pile, :card

        def initialize(mouse_pos, areas)
          @areas     = areas
          @mouse_pos = mouse_pos
          @area, @pile, @card = nil, nil, nil
        end

        def gather!
          find_all
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

        protected

        def find_all
          find_area and find_pile and find_card
        end

        def find_area
          @area = @areas.values.to_a.find do |area|
            area.cards.find { |card| card.hit?(mouse_pos) }
          end
        end

        def find_pile
          find_area unless @area
          @pile = @area.piles.find do |pile|
            pile.cards.find { |card| card.hit?(mouse_pos) }
          end
        end

        def find_card
          find_pile unless @pile
          @card = @pile.cards.reverse.find { |card| card.hit?(mouse_pos) }
        end

      end
    end
  end
end
