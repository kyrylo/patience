require_relative 'helper'

module Patience
  class TestPile < MiniTest::Unit::TestCase

    def setup
      cards = Array.new 10, Card.new(12, 3)
      @pile = Pile.new(cards)
    end

    def test_pile_has_cards
      assert @pile.cards
    end

    def test_pile_has_background
      assert @pile.background
      assert_instance_of Ray::Sprite, @pile.background
    end

    def test_pile_has_position
      assert_equal [0, 0], @pile.pos.to_a
    end

    def test_position_of_a_pile_can_be_set
      pile = @pile.dup
      pile.pos = [105, 20]
      assert_equal [105, 20], pile.pos.to_a
    end

    def test_cards_can_be_counted_in_a_pile
      assert_equal 10, @pile.size
    end

    def test_cards_can_be_shuffled_off_from_a_pile
      pile = @pile.dup
      assert_equal 6, pile.shuffle_off!(6).size
      assert_equal 4, pile.size
    end

  end
end
