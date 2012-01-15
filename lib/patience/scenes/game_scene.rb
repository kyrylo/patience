module Patience
  class GameScene < Ray::Scene

    def find_card_in_pile(pile)
      pile.cards.reverse.find do |card|
        Cursor.clicked_on?(card, mouse_pos) unless card.face_down?
      end
    end

    def setup
      @background_color = Ray::Color.new(31, 95, 25)
      @deck       = Deck.new
      @tableau    = Tableau.new(@deck.shuffle_off 28)
      @stock      = Stock.new(@deck.shuffle_off 24)
      @waste      = Waste.new
      @foundation = Foundation.new
    end

    def register
      add_hook :quit, method(:exit!)
      add_hook :key_press, key(:q), method(:exit!)

      on :mouse_press do
        [@tableau, @stock].find { |p| @clicked_card = find_card_in_pile(p) }
        Cursor.pick_up(@clicked_card, mouse_pos) if @clicked_card && @clicked_card.face_up?
      end

      on :mouse_release do
        @clicked_card = nil
      end

      always do
        Cursor.drag(@clicked_card, mouse_pos) if @clicked_card
      end

    end

    def render(win)
      win.clear @background_color
      @stock.draw_on win
      @waste.draw_on win
      @foundation.draw_on win
      @tableau.draw_on win
    end

  end
end
