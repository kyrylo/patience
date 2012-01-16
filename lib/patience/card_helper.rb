module Patience
  module CardHelper

    def draw_on(win)
      if self.respond_to?(:piles)
        piles.each do |pile|
          win.draw pile.background
          pile.cards.each { |card| win.draw card.sprite }
        end
      else
        win.draw background
        cards.each { |card| win.draw card.sprite }
      end
    end

    def card_at(mouse_pos)
      cards.reverse.find { |card| card.sprite.to_rect.contain?(mouse_pos) }
    end

  end
end
