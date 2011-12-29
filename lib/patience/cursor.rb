module Patience
  module Cursor

    class << self
      def clicked_on?(obj, mouse_pos)
        obj.sprite.to_rect.contain?(mouse_pos)
      end

      def pick_up(obj, mouse_pos)
        @offset = obj.sprite.pos - mouse_pos
      end

      def drag(obj, mouse_pos)
        obj.sprite.pos = mouse_pos + @offset
      end
    end

  end
end
