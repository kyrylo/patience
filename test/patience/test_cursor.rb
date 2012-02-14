require_relative 'helper'

module Patience
  class TestCursor < MiniTest::Unit::TestCase

    def setup
      @cursor = Cursor.new
      @card = Card.new(13, 3)
      areas = { :area => Area.new }
      areas[:area].piles.first << @card
      offset = Ray::Vector2[20, 20]
      mouse_pos = Ray::Vector2.new
      @cursor.mouse_pos = mouse_pos
      @cursor.click = EventHandler::Click.new(mouse_pos, areas)
      @cursor.drag = EventHandler::Drag.new(@card, offset)
      @cursor.drop = EventHandler::Drop.new(@cursor, areas)
    end

    def test_cursor_can_be_created
      assert Cursor.new
    end

    def test_cursor_responds_to_instance_methods
      methods = [:mouse_pos, :mouse_pos=, :click, :click!, :click=, :drag,
                 :drag=, :drop, :clicked_something?, :still_on_something?,
                 :movable?, :carrying_card?, :drawable?, :drop!, :drop=]
      methods.each { |method| assert_respond_to @cursor, method }
    end

    def test_cursor_responds_to_delegated_methods
      delegated_methods = [:card, :pile, :offset, :draggable?]
      delegated_methods.each { |method| assert_respond_to @cursor, method }
    end

    def test_cursor_can_drop_objects
      cursor = @cursor.dup
      assert cursor.click
      assert cursor.drag
      cursor.drop!
      refute cursor.click
      refute cursor.drag
    end

    def test_cursor_can_check_whether_it_clicked_something
      cursor = @cursor.dup
      assert cursor.clicked_something?
      cursor.drop!
      refute cursor.clicked_something?
    end

    def test_cursor_can_check_whether_it_still_hovers_clicked_object
      cursor = @cursor.dup
      assert cursor.still_on_something?

      areas = { :area => Area.new }
      areas[:area].piles.first << @card
      areas
      @cursor.click = EventHandler::Click.new(cursor.mouse_pos, areas)
      assert cursor.still_on_something?

      cursor.mouse_pos = Ray::Vector2[1000, 1000]
      refute cursor.still_on_something?

      cursor.card.sprite.pos = cursor.mouse_pos
      assert cursor.still_on_something?

    end

    def test_cursor_can_check_if_the_object_is_movable
      cursor = @cursor.dup
      assert cursor.movable?
      cursor.card.face_down
      refute cursor.movable?
      cursor.drop
      cursor.movable?
    end

    def test_cursor_can_check_whether_it_is_carrying_a_card
      cursor = @cursor.dup
      assert cursor.carrying_card?

      cursor.drop!
      refute cursor.carrying_card?

      areas = { :area => Area.new }
      areas[:area].piles.first << @card
      @cursor.click = EventHandler::Click.new(cursor.mouse_pos, areas)
      refute cursor.carrying_card?
    end

  end
end
