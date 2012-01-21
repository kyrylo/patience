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
      @areas      = [@tableau, @stock, @waste, @foundation]
    end

    def register
      add_hook :quit, method(:exit!)
      add_hook :key_press, key(:q), method(:exit!)

      on :mouse_press do
        @cursor.click = find_card_at(@cursor.mouse_pos)
        if @cursor.pickable? && @cursor.obj.face_up?
          @cursor.pick_up
        else
          @cursor.click = nil # Click or it didn't happen.
        end
      end

      on :mouse_release do
        @cursor.drop
      end

      always do
        @cursor.mouse_pos = mouse_pos
        @cursor.drag if @cursor.obj
      end

    end

    def render(win)
      win.clear @background_color
      @areas.each { |area| area.draw_on(win) }
      @cursor.obj.draw_on(win) if @cursor.drawable?
    end

    protected

    def find_card_at(mouse_pos)
      @areas.map { |area| area.card_at(mouse_pos) }.compact.pop
    end

  end
end
