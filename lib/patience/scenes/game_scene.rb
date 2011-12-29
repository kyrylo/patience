module Patience
  class GameScene < Ray::Scene

    def setup
      @background_color = Ray::Color.new(31, 95, 25)
      @deck = Deck.new
      a = 0
      @deck.cards.each do |card|
        card.sprite.pos += [a, 0]
        a += 10
      end
    end

    def register
      add_hook :quit, method(:exit!)
      add_hook :key_press, key(:q), method(:exit!)

      always do
        on :mouse_press do
          @clicked_card = @deck.cards.find { |card| Cursor.clicked_on?(card, mouse_pos) }
          Cursor.pick_up(@clicked_card, mouse_pos) if @clicked_card
        end

        on :mouse_release do
          @clicked_card = nil
        end

        Cursor.drag(@clicked_card, mouse_pos) if @clicked_card
      end
    end

    def render(win)
      win.clear(@background_color)
      @deck.cards.each do |card|
        win.draw(card.sprite)
      end
    end

  end
end
