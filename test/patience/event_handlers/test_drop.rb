require_relative '../helper'

module Patience
  class TestDrop < MiniTest::Unit::TestCase

    class EventHandler::Click
      attr_accessor :mouse_pos
    end

    class Dummy < EventHandler::Drop
      attr_accessor :dropped_card
    end

    def setup
      @mouse_pos = Ray::Vector2[32, 166]
      @deck = Deck.new
      @areas = { :tableau => Tableau.new(@deck.shuffle_off! 28),
                 :waste => Waste.new }
      @click = EventHandler::Click.new(@mouse_pos, @areas)
      @drop = Dummy.new(@click, @areas)
    end

    def test_drop_can_find_card_beneath
      @drop.dropped_card.pos = Ray::Vector2[0, 0]
      assert_nil @drop.send(:find_card_beneath)
      @drop.dropped_card.pos = Ray::Vector2[252, 218]
      assert_equal Card, @drop.send(:find_card_beneath).class
    end

    def test_drop_can_check_if_a_card_is_operative
      @drop.dropped_card.pos = Ray::Vector2[0, 0]
      refute @drop.send(:operative?, @click.card)
      @drop.dropped_card.pos = Ray::Vector2[252, 218]
      assert @drop.send(:operative?, @areas[:tableau].piles[2].cards.last)
    end

    def test_drop_can_call_off_a_card
      assert_equal Ray::Vector2[31, 165], @drop.dropped_card.pos
      @drop.dropped_card.pos = Ray::Vector2[0, 0]
      assert_equal Ray::Vector2[0, 0], @drop.dropped_card.pos
      @drop.send(:call_off)
      assert_equal Ray::Vector2[31, 165], @drop.dropped_card.pos
    end

  end
end
