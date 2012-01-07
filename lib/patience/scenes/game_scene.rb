module Patience
  class GameScene < Ray::Scene

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
        @clicked_card = @deck.cards.reverse.find do |card|
          Cursor.clicked_on?(card, mouse_pos)
        end

        if @clicked_card
          @deck.cards << @deck.cards.delete(@clicked_card)
          Cursor.pick_up(@clicked_card, mouse_pos)
        end
      end

      on :mouse_release do
        @clicked_card = nil
      end

      always do
        Cursor.drag(@clicked_card, mouse_pos) if @clicked_card
      end

    end

    def render(win)
      win.clear(@background_color)
      win.draw @stock.background
      @stock.cards.each { |card| win.draw card.sprite }

      win.draw @waste.background
      unless @waste.cards.empty?
        win.draw @waste.cards.each { |card| win.draw card.sprite }
      end

      @foundation.piles.each { |pile| win.draw pile.background }

      @tableau.piles.each do |pile|
        win.draw pile.background
        pile.cards.each { |card| win.draw card.sprite }
      end
    end

  end
end
