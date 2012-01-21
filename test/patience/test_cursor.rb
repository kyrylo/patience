require_relative 'helper'

module Patience
  class TestCursor < MiniTest::Unit::TestCase

    def setup
      @cursor   = Cursor.new
      @object   = Card.new(13, 3)
      mouse_pos = Ray::Vector2.new
      @cursor.click = @object
      @cursor.mouse_pos = mouse_pos
    end

    def test_cursor_can_be_created
      assert Cursor.new
    end

    def test_cursor_responds_to_methods
      [:mouse_pos, :mouse_pos=, :obj, :click=,
      :clickable?, :drag, :pick_up, :drop, :drawable?,
      :pickable?].each { |method| assert_respond_to @cursor, method }
    end

    def test_click_on_the_object_works
      assert_equal "Ace of Spades", @cursor.obj.to_s
    end

    def test_cursor_can_check_whether_the_object_is_clickable
      cursor = @cursor.dup
      assert cursor.clickable?
      cursor = Cursor.new
      refute cursor.clickable?
    end

    def test_cursor_can_drag_objects
      cursor = @cursor.dup
      cursor.pick_up
      assert_equal Ray::Vector2.new(0, 0), cursor.obj.pos

      cursor.mouse_pos += [20, 20]
      cursor.drag
      assert_equal Ray::Vector2.new(20, 20), cursor.obj.pos

      cursor.mouse_pos += [1000, 1]
      cursor.drag
      assert_equal Ray::Vector2.new(1020, 21), cursor.obj.pos

      cursor.mouse_pos -= [0, 800]
      cursor.drag
      assert_equal Ray::Vector2.new(1020, -779), cursor.obj.pos
    end

    def test_cursor_can_pick_up_objects
      cursor = @cursor.dup
      assert_equal Ray::Vector2.new(0, 0), cursor.pick_up
      cursor.mouse_pos += [20, 20]
      assert_equal Ray::Vector2.new(-20, -20), cursor.pick_up
      cursor.mouse_pos += [100, 100]
      assert_equal Ray::Vector2.new(-120, -120), cursor.pick_up
      cursor.mouse_pos -= [300, 300]
      assert_equal Ray::Vector2.new(180, 180), cursor.pick_up
    end

    def test_cursor_can_drop_objects
      cursor = @cursor.dup
      assert cursor.obj
      cursor.drop
      refute cursor.obj
    end

    def test_cursor_can_check_whether_clicked_object_can_be_drawn
      cursor = @cursor.dup
      assert cursor.drawable?
      cursor.drop
      cursor.click = Array.new
      refute cursor.drawable?
    end

    def test_cursor_can_check_whether_clicked_card_can_be_picked
      cursor = @cursor.dup
      assert cursor.pickable?
      cursor.drop
      cursor.click = Array.new
      refute cursor.pickable?
    end

  end
end
