require_relative 'helper'

module Patience
  class TestCursor < MiniTest::Unit::TestCase

    def setup
      @cursor = Cursor.new
      @card = Card.new(13, 3)
      @areas = { :area => Area.new }
      @areas[:area].piles.first << @card
      offset = Ray::Vector2[20, 20]
      mouse_pos = Ray::Vector2.new
      @cursor.mouse_pos = mouse_pos
      @cursor.click = EventHandler::Click.new(mouse_pos, @areas)
      @cursor.drag = EventHandler::Drag.new(@card, offset)
      @cursor.drop = EventHandler::Drop.new(@cursor, @areas)
    end

    def test_cursor_can_drop_objects
      assert @cursor.click
      assert @cursor.drag
      @cursor.drop!
      refute @cursor.click
      refute @cursor.drag
    end

    def test_cursor_can_check_whether_it_clicked_something
      assert @cursor.clicked_something?
      @cursor.drop!
      refute @cursor.clicked_something?
    end

    def test_cursor_can_check_whether_it_still_hovers_clicked_object
      assert @cursor.still_on_something?

      @areas[:area].piles.first << @card
      @cursor.click = EventHandler::Click.new(@cursor.mouse_pos, @areas)
      assert @cursor.still_on_something?

      @cursor.mouse_pos = Ray::Vector2[1000, 1000]
      refute @cursor.still_on_something?

      @cursor.card.sprite.pos = @cursor.mouse_pos
      assert @cursor.still_on_something?

    end

    def test_cursor_can_check_if_the_object_is_movable
      assert @cursor.movable?
      @cursor.card.face_down
      refute @cursor.movable?
      @cursor.drop!
      refute @cursor.movable?
    end

    def test_cursor_can_check_whether_it_is_carrying_a_card
      assert @cursor.carrying_card?
      @cursor.drop!
      refute @cursor.carrying_card?
      cursor = Cursor.new
      cursor.click = EventHandler::Click.new(Ray::Vector2[800, 800], @areas)
      refute cursor.carrying_card?
    end

  end
end
