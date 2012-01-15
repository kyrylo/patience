module Patience
  module Drawing

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

  end
end
