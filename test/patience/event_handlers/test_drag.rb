require_relative '../helper'

module Patience
  class TestDrag < MiniTest::Unit::TestCase

    def setup
      @mouse_pos = Ray::Vector2[32, 166]
      @areas = { :tableau => Tableau.new([Card.new(1, 1)]) }
      @click  = EventHandler::Click.new(@mouse_pos, @areas)
      @drag = EventHandler::Drag.new(@click.card, @click.offset)
    end

    def test_drag_can_be_created
      assert EventHandler::Drag.new(@click, @click.offset)
    end

    def test_drag_is_an_instance_of_drag_class
      assert_instance_of EventHandler::Drag, @drag
    end

    def test_drag_accepts_two_arguments
      assert_raises(ArgumentError) { EventHandler::Drag.new }
      assert_raises(ArgumentError) { EventHandler::Drag.new(@mouse_pos) }
      assert_raises(ArgumentError) do
        EventHandler::Drag.new(@mouse_pos, @areas, 10)
      end
    end

    def test_drag_responds_to_instance_methods
      methods = [:move, :draggable?]
      methods.each { |method| assert_respond_to @drag, method }
    end

    def test_drag_can_move_cards
      click = @click.dup
      drag  = @drag.dup
      mouse_pos = @mouse_pos.dup
      mouse_pos += [200, 200]
      assert_equal Ray::Vector2[31, 165], click.card.sprite.pos
      drag.move(mouse_pos)
      assert_equal Ray::Vector2[231, 365], click.card.sprite.pos
      mouse_pos += [-231, -365]
      drag.move(mouse_pos)
      assert_equal Ray::Vector2[0, 0], click.card.sprite.pos
    end

    def test_drag_can_check_whether_a_card_is_draggable
      assert @drag.draggable?
      click  = EventHandler::Click.new(Ray::Vector2[0, 0], @areas)
      drag = EventHandler::Drag.new(click.card, click.offset)
      refute drag.draggable?
    end

  end
end
