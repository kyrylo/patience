module Patience
  ###
  # Patience::GameScene is a main scene of the game. All stuff happens here.
  class GameScene < Ray::Scene

    def setup
      @bg_sprite  = Ray::Sprite.new path_of('patience/sprites/table_bg.png')
      @cursor     = Cursor.new
      @deck       = Deck.new
      @deck.cards.shuffle!

      @tableau    = Tableau.new(@deck.shuffle_off! 28)
      @stock      = Stock.new(@deck.shuffle_off! 24)
      @waste      = Waste.new
      @foundation = Foundation.new

      @areas      = { :tableau    => @tableau,
                      :stock      => @stock,
                      :waste      => @waste,
                      :foundation => @foundation }
    end

    def register
      add_hook :quit, method(:exit!)
      add_hook :key_press, key(:q), method(:exit!)

      # If mouse button pressed, create Click event. If a card has
      # been clicked, create Drag event. Drag only face up cards.
      on :mouse_press do
        @cursor.click = EventHandler::Click.new(@cursor.mouse_pos, @areas)
        if @cursor.carrying_card?
          @cursor.drag  = EventHandler::Drag.new(@cursor)
        end
      end

      on :mouse_motion do
        if @cursor.movable? and @cursor.click.not.stock?
          @cursor.drag.move(@cursor.mouse_pos)
        end
      end

      on :mouse_release do
        @cursor.click! if @cursor.clicked_something?
        if @cursor.carrying_card?
          @cursor.drop = EventHandler::Drop.new(@cursor.click, @areas)
          @cursor.drop! unless @cursor.click.stock?
        end
      end

      always do
        @cursor.mouse_pos = mouse_pos
      end

    end

    def render(win)
      win.draw @bg_sprite
      @areas.values.to_a.each { |area| area.draw_on(win) }
      # Draw the card, which is being dragged.
      if @cursor.drawable?
        @cursor.click.cards.keys.each { |card| card.draw_on(win) }
      end
    end

  end
end
