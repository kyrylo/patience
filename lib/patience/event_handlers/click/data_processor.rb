module Patience
  class EventHandler
    class Click
      ###
      # Patience::EventHandler::Click::DataProcessor objects process
      # information, that has been collected by Click::DataCollector.
      # Example:
      #   processor = DataProcessor.new(mouse_pos, areas)
      #   processor.card #=> Ace of Spades
      #   processor.stock? #=> false
      #
      class DataProcessor
        attr_reader :data

        # Accepts two arguments: mouse_pos and areas, which are
        # needed for click scenarios. DataProcessor creates
        # DataCollector object and gathers information from it.
        # Example:
        #   areas = [stock, waste]
        #   processor = DataProcessor.new(mouse_pos, areas)
        #   processor.waste? #=> false
        #   processor.stock? #=> true
        #   processor.card #=> Ace of Hearts
        #
        def initialize(mouse_pos, areas)
          @mouse_pos = mouse_pos
          @areas = areas
          @data = DataCollector.new(mouse_pos, areas)
          @data.gather!
        end

        # Returns true, if DataCollector hasn't found
        # anything. Otherwise, returns false.
        # Example:
        #   processor.card #=> nil
        #   processor.pile #=> nil
        #   processor.nothing? #=> true
        #
        #   processor.card #=> Eight of Clubs
        #   processor.area #=> #<Stock>
        #   processor.nothing? #=> false
        #
        def nothing?
          data.to_a.compact.size.zero?
        end

        # The opposite of #nothing?. Returns true, if DataCollector
        # has found anything. Otherwise, returns false.
        # Example:
        #   processor.card #=> nil
        #   processor.pile #=> nil
        #   processor.something? #=> false
        #
        #   processor.card #=> Eight of Clubs
        #   processor.area #=> #<Stock>
        #   processor.nothing? #=> true
        #
        def something?
          not nothing?
        end

        # Returns pile if there is any. Otherwise, returns nil.
        # Example:
        #   processor.pile #=> #<Pile>
        #
        def pile
          data.to_h[:pile]
        end

        # Returns card if there is any. Otherwise, returns nil.
        # Example:
        #   processor.card #=> #<Card>
        #
        def card
          data.to_h[:card]
        end

        # Returns subtraction between the card and mouse position at the moment
        # of click, if cursor clicked the card. Otherwise, returns nil.
        # Example:
        #   @processor.pick_up #=> (-32, 42)
        #
        def pick_up
          data.to_h[:card].sprite.pos - @mouse_pos if card
        end

        # Returns true, if the clicked area is Stock.
        def stock?
          data.to_h[:area].instance_of? Stock
        end

        # Returns true, if the clicked area is Waste.
        def waste?
          data.to_h[:area].instance_of? Waste
        end

        # Returns true, if the clicked area is Tableau.
        def tableau?
          data.to_h[:area].instance_of? Tableau
        end

        # Returns true, if the clicked area is Foundation.
        def foundation?
          data.to_h[:area].instance_of? Foundation
        end

        # Returns Proc object of Stock scenario. It means,
        # that the scenario can be called on demand.
        # Example:
        #   scenario = stock_scenario
        #   scenario.call if opportune_moment?
        #
        def stock_scenario
          # TODO: Current implementation is poor,
          # because background updates on every turn.
          Proc.new do
            if pile.empty?
              @areas[:waste].cards.each do |card|
                card.face_down
                @areas[:stock].piles.first << card
              end
            else
              card.face_up
              @areas[:waste].piles.first << exempt(card)
            end

            if pile.empty?
              empty_stock = 'patience/sprites/empty_stock.png'
              pile.background = Ray::Sprite.new path_of(empty_stock)
            else
              pile_background = 'patience/sprites/pile_background.png'
              pile.background = Ray::Sprite.new path_of(pile_background)
            end
          end
        end

        def waste_scenario
          Proc.new do
          end
        end

        def tableau_scenario
          Proc.new do
          end
        end

        def foundation_scenario
          Proc.new do
          end
        end

        protected

        # Deletes card from the pile and returns it. Used in scenarios.
        # Example
        #   two = Card.new(1, 1)
        #   processor.exempt(two) #=> Two of Hearts
        #
        def exempt(card)
          pile.cards.delete(card)
        end

      end
    end
  end
end
