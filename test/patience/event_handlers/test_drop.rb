require_relative '../helper'

module Patience
  class TestDrop < MiniTest::Unit::TestCase

    class Dummy < EventHandler::Drop
      attr_accessor :dropped_card
    end

    def setup
      @mouse_pos = Ray::Vector2[32, 166]
      @deck = Deck.new
      @areas = { :tableau => Tableau.new(@deck.shuffle_off! 28),
                 :waste => Waste.new }
      @click = EventHandler::Click.new(@mouse_pos, @areas)
      @drop = Dummy.new(@click.card, @click.card_init_pos,
                                     @mouse_pos, @areas)
    end

    def test_drop_can_be_created
      assert EventHandler::Drop.new(Card.new(1, 1), Ray::Vector2[0, 0],
                                @mouse_pos, @areas)
    end

    def test_drop_accepts_four_arguments
      assert_raises(ArgumentError) { EventHandler::Drop.new }
      assert_raises(ArgumentError) { EventHandler::Drop.new(1) }
      assert_raises(ArgumentError) { EventHandler::Drop.new(1, 2) }
      assert_raises(ArgumentError) { EventHandler::Drop.new(1, 2, 3) }
      assert_raises(ArgumentError) { EventHandler::Drop.new(1, 2, 3, 4, 5) }
    end

    def test_drop_responds_to_instance_methods
      methods = [:scenario]
      methods.each { |method| assert_respond_to @drop, method }
    end

    def test_drop_responds_to_protected_methods
      protected_methods = [:find_card_beneath, :operative?, :call_off]
      protected_methods.each { |method| assert_respond_to @drop, method }
    end

    def test_drop_can_find_card_beneath
      @drop.dropped_card.pos = Ray::Vector2[0, 0]
      assert_nil @drop.send(:find_card_beneath)
      @drop.dropped_card.pos = Ray::Vector2[165, 165]
      assert_equal Card, @drop.send(:find_card_beneath).class
    end

    def test_drop_can_check_if_a_card_is_operative
      @drop.dropped_card.pos = Ray::Vector2[0, 0]
      refute @drop.send(:operative?, @click.card)
      @drop.dropped_card.pos = Ray::Vector2[165, 165]
      assert @drop.send(:operative?, @areas[:tableau].piles[1].cards.last)
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
