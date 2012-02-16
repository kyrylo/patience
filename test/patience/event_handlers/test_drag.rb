require_relative '../helper'

module Patience
  class TestDrag < TestCase

    def setup
      @mouse_pos = Ray::Vector2[32, 166]
      @areas = { :tableau => Tableau.new([Card.new(1, 1)]) }
      @click  = EventHandler::Click.new(@mouse_pos, @areas)
      @drag = EventHandler::Drag.new(@click.card, @click.offset)
    end

    test 'Drag can move cards' do
      @mouse_pos += [200, 200]
      assert_equal Ray::Vector2[31, 165], @click.card.sprite.pos
      @drag.move(@mouse_pos)
      assert_equal Ray::Vector2[231, 365], @click.card.sprite.pos
      @mouse_pos += [-231, -365]
      @drag.move(@mouse_pos)
      assert_equal Ray::Vector2[0, 0], @click.card.sprite.pos
    end

    test 'Drag can check, whether a card is draggable' do
      assert @drag.draggable?
      click  = EventHandler::Click.new(Ray::Vector2[0, 0], @areas)
      drag = EventHandler::Drag.new(click.card, click.offset)
      refute drag.draggable?
    end

  end
end
