require_relative 'helper'

module Patience
  class TestCursor < MiniTest::Unit::TestCase

    def setup
      @object = Card.new(12, 3)
      @object.sprite.pos = [100, 100]
      @mouse_pos = Ray::Vector2.new
    end

    def test_object_can_be_clicked
      mouse_pos = @mouse_pos
      assert !Cursor.clicked_on?(@object, mouse_pos)

      mouse_pos += [500, 500]
      assert !Cursor.clicked_on?(@object, mouse_pos)

      mouse_pos -= [350, 350]
      assert Cursor.clicked_on?(@object, mouse_pos)

      object = @object.dup
      object.sprite.pos += [500, 500]
      assert !Cursor.clicked_on?(@object, mouse_pos)

      mouse_pos += [450, 450]
      assert Cursor.clicked_on?(object, mouse_pos)
    end

    def test_cursor_can_pick_up_stuff
      mouse_pos = @mouse_pos
      mouse_pos += [100, 100]
      assert_equal [0, 0], Cursor.pick_up(@object, mouse_pos).to_a

      object = @object.dup
      object.sprite.pos += [500, 500]
      mouse_pos += [650, 650]
      assert_equal [-150, -150], Cursor.pick_up(object, mouse_pos).to_a
    end

    def test_cursor_can_drag_stuff
      object = @object.dup
      mouse_pos = @mouse_pos
      Cursor.pick_up(object, mouse_pos)
      Cursor.drag(object, mouse_pos)
      assert_equal [100, 100], object.sprite.pos.to_a

      mouse_pos += [50, 50]
      Cursor.drag(object, mouse_pos)
      assert_equal [150, 150], object.sprite.pos.to_a

      mouse_pos += [345, 210]
      Cursor.drag(object, mouse_pos)
      assert_equal [495, 360], object.sprite.pos.to_a
    end

  end
end
