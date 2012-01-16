module Patience
  class GameScene < Ray::Scene

    def setup
      @background_color = Ray::Color.new(31, 95, 25)
      @deck       = Deck.new
      @tableau    = Tableau.new(@deck.shuffle_off 28)
      @stock      = Stock.new(@deck.shuffle_off 24)
      @waste      = Waste.new
      @foundation = Foundation.new
      @zones      = [@tableau, @stock, @waste, @foundation]
    end

    def register
      add_hook :quit, method(:exit!)
      add_hook :key_press, key(:q), method(:exit!)

      on :mouse_press do
        @clicked_card = find_card_at(mouse_pos)
        Cursor.pick_up(@clicked_card, mouse_pos) if @clicked_card && @clicked_card.face_up?
      end

      on :mouse_release do
        @clicked_card = nil
      end

      always do
        Cursor.drag(@clicked_card, mouse_pos) if @clicked_card && @clicked_card.face_up?
      end

    end

    def render(win)
      win.clear @background_color
      @zones.each { |zone| zone.draw_on(win) }
    end

    def find_card_at(mouse_pos)
      @zones.map { |zone| zone.card_at(mouse_pos) }.compact.pop
    end

  end
end
