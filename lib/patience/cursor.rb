module Patience
  ###
  # Patience::Cursor handles operations with mouse. The whole point of this is
  # to provide dragging of cards.
  class Cursor
    attr_accessor :mouse_pos, :click

    # Sets click to the state, when nothing was clicked.
    def drop
      @click = nil
    end

    # Returns true, if cursor clicked anything
    # but non-game objects. Otherwise returns false.
    def active?
      click and click.not.nothing?
    end

  end
end
