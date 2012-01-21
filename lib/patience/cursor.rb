module Patience
  ###
  # Patience::Cursor handles operations with mouse. The whole point of this is
  # to provide dragging of cards.
  class Cursor
    attr_accessor :mouse_pos
    attr_reader :obj

    # Sets obj to given object. That means, that you
    # would be able some or any instance methods of Cursor.
    def click=(obj)
      @obj = obj
    end

    # Returns true if there is any object. Otherwise returns false.
    def clickable?
      obj.not.nil?
    end

    # Changes position of the obj regarding mouse position.
    def drag
      obj.sprite.pos = mouse_pos + @offset
    end

    # Returns the offset: the value of the
    # difference of obj's position and current mouse position.
    def pick_up
      @offset = obj.sprite.pos - mouse_pos
    end

    # Sets obj to nil. That means, that you would be
    # able to use none of the instance methods of Cursor.
    def drop
      @obj = nil
    end

    # Returns true if the obj responds to sprite. Otherwise returns false.
    def drawable?
      obj.respond_to?(:sprite)
    end

    # Just a syntactic sugar for more readability. Returns the result of the
    # pickable? metod. If you can draw it, then you also can pick it, don't you?
    def pickable?
      drawable?
    end

  end
end
