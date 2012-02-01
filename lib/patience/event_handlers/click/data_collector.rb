module Patience
  class EventHandler
    class Click
      ###
      # Patience::EventHandler::Click::DataCollector is a class, which collects
      # information about the click. Namely: area, pile and card, that has been
      # clicked by the cursor. A DataCollector object can represend information
      # as hash, string, or array.
      # Example:
      #   data = DataCollector.new(mouse_pos, areas)
      #   data.pile #=> nil
      #   data.gather!
      #   data.pile #=> #<Pile>
      #
      class DataCollector
        attr_reader :mouse_pos, :area, :pile, :card

        # Instantiates a DataCollector object. A DataCollector object collects
        # information about clicked card: finds the very card, pile, where the
        # card is currently sit and area of the pile. It takes mouse position
        # and areas as arguments, from which it gathers information.
        # Example:
        #   data = DataCollector.new(mouse_pos, areas)
        #   data.gather!
        #   data.card #=> #<Card>
        #   data.pile #=> #<Pile>
        #   data.area #=> #<Area>
        #
        def initialize(mouse_pos, areas)
          @areas     = areas
          @mouse_pos = mouse_pos
          @area, @pile, @card = nil, nil, nil
        end

        # Gathers all available information from the click point. If the
        # data is incomplete, leaves the result, and tries to find clicked
        # pile, if there has been any. In case, there is no information
        # regarding click point (e.g. clicked nothing), returns nil.
        # Example:
        #   data = DataCollector.new(mouse_pos, areas)
        #   data.gather!
        #   data.card #=> nil
        #   data.pile #=> #<Pile>
        #
        def gather!
          find_all || find_pile if @pile.nil?
        end

        # Returns hash representation of the data.
        # Example:
        #   data = DataCollector.new(mouse_pos, areas)
        #   data.gather!
        #   data.to_h #=> {:area => #<Area>, :pile => #<Pile>, :card => #<Card>}
        #
        def to_h
          { :area => area, :pile => pile, :card => card }
        end

        # Returns array representation of the data.
        # Example:
        #   data = DataCollector.new(mouse_pos, areas)
        #   data.gather!
        #   data.to_a #=> [#<Area>, #<Pile>, #<Card>]
        #
        def to_a
          [area, pile, card]
        end

        # TODO: Amend method, so it can show only pile, when pile is clicked.
        # Returns string representation of the data.
        # Example:
        #   data = DataCollector.new(mouse_pos, areas)
        #   data.gather!
        #   data.to_s #=> "Click on card Two of Hearts, in pile
        #                  #<Pile>, in the region of #<Area>"
        def to_s
          "Click on card #{card}, in pile #{pile}, in the region of #{area}"
        end

        protected

        # Finds all available information about the click point, videlicet:
        # clicked card, area and pile, where this card is situated. If there is
        # no information regarding click point (e.g. clicked nothing), assigns
        # area, pile and card with nil.
        def find_all
          @area = @areas.values.to_a.find do |area|
            @pile = area.piles.find { |pile|
              @card = pile.cards.reverse.find { |card| card.hit?(mouse_pos) }
            }
          end
        end

        # Finds in the clicked point pile and area, where this pile is situated.
        def find_pile
          @area = @areas.values.to_a.find { |area|
            @pile = area.piles.find { |pile| pile.hit?(mouse_pos) }
          }
        end

      end
    end
  end
end
