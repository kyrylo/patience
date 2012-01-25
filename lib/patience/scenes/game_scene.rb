module Patience
  class GameScene < Ray::Scene

    def setup
      @background_color = Ray::Color.new(31, 95, 25)
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

      on :mouse_press do
        @cursor.click = EventHandler::Click.new(@cursor.mouse_pos, @areas)
        @cursor.click.exec unless @cursor.click.nothing?
      end

      on :mouse_release do
        @cursor.drop
      end

      always do
        @cursor.mouse_pos = mouse_pos
      end

    end

    def render(win)
      win.clear @background_color
      @areas.values.to_a.each { |area| area.draw_on(win) }
      if @cursor.active? && @cursor.click.card.face_up?
        @cursor.click.card.draw_on(win) 
      end
    end

  end
end
