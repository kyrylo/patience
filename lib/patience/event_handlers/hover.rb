require_relative '../processable'

module Patience
  module EventHandler
    class Hover
      include Processable

      def initialize
        @glow_image = Ray::Sprite.new image_path('glow')
      end

      def glow(card)
        @glow_image.pos = card.pos - [8, 8]
        @glow_image
      end

      def mouse_over?(mouse_pos, obj)
        obj.hit?(mouse_pos)
      end

    end
  end
end
