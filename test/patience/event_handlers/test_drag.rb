require_relative '../helper'

module Patience
  class TestDrag < TestCase

    class Dummy < EventHandler::Drag
      def initialize
        @card = Card.new(1, 1)
        @tail_cards = {@card => 0, Card.new(2, 2) => 0, Card.new(3, 3) => 0}
        @offset = Ray::Vector2[20, 20]
      end
    end

    def setup
      @mouse_pos = Ray::Vector2[0, 0]
      @dummy = Dummy.new
      @areas = { :tableau => Tableau.new([Card.new(1, 1)]) }
      @cursor = Cursor.new
      @cursor.mouse_pos = @mouse_pos
      @cursor.click = EventHandler::Click.new(@cursor.mouse_pos, @areas)
    end

    test 'A drag can move cards' do
      assert_equal Ray::Vector2[0, 0], @dummy.card.sprite.pos

      @mouse_pos += [200, 200]
      @dummy.move(@mouse_pos)
      assert_equal Ray::Vector2[220, 220], @dummy.card.sprite.pos

      @mouse_pos += [-231, -365]
      @dummy.move(@mouse_pos)
      assert_equal Ray::Vector2[-11, -145], @dummy.card.sprite.pos
    end

    test 'A drag can check, whether a card is draggable' do
      assert @dummy.draggable?

      @cursor.mouse_pos = Ray::Vector2[800, 500]
      @cursor.click = EventHandler::Click.new(@cursor.mouse_pos, @areas)
      drag = EventHandler::Drag.new(@cursor)
      refute drag.draggable?
    end

  end
end
