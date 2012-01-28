module Patience
  class Cursor
    attr_accessor :mouse_pos, :click

    def drop
      @click = nil
    end

    def active?
      click and click.not.nothing? and click.card
    end

  end
end
