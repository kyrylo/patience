module Patience
  ###
  # Patience::GameScene is a main scene of the game. All stuff happens here.
  class GameScene < Ray::Scene

    def setup
      @bg_color   = Ray::Color.new(31, 95, 25)
      @cursor     = Cursor.new
      @deck       = Deck.new
      @tableau    = Tableau.new(@deck.shuffle_off! 28)
      @stock      = Stock.new(@deck.shuffle_off! 24)
      @waste      = Waste.new
      @foundation = Foundation.new
      @areas      = { :tableau => @tableau, :stock => @stock,
                      :waste => @waste, :foundation => @foundation }
    end

    def register
      add_hook :quit, method(:exit!)
      add_hook :key_press, key(:q), method(:exit!)

      # If mouse button pressed, create Click event. If a card has
      # been clicked, create Drag event. Drag only face up cards.
      on :mouse_press do
        @cursor.click = EventHandler::Click.new(@cursor.mouse_pos, @areas)

        if @cursor.carrying_card?
          @cursor.drag  = EventHandler::Drag.new(@cursor.card, @cursor.offset)
          on :mouse_motion do
            if @cursor.movable? && @cursor.click.not.stock?
              @cursor.drag.move(@cursor.mouse_pos) 
            end
          end
        end

      end

      on :mouse_release do
        @cursor.click! if @cursor.clicked_something?
        if @cursor.carrying_card?
          @cursor.drop = EventHandler::Drop.new(@cursor.card,
                               @cursor.card_init_pos, @cursor.mouse_pos, @areas)
          @cursor.drop! unless @cursor.click.stock?
        end
      end

      always do
        @cursor.mouse_pos = mouse_pos
      end

    end

    def render(win)
      win.clear @bg_color
      @areas.values.to_a.each { |area| area.draw_on(win) }
      # Draw the card, which is being dragged.
      @cursor.click.card.draw_on(win) if @cursor.drawable?
    end

  end
end
