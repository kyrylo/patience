require_relative 'helper'

module Patience
  class TestStockArea < MiniTest::Unit::TestCase

    def setup
      @deck = Deck.new
      @deck.cards.shuffle!
      @stock = Stock.new(@deck.shuffle_off! 24)
    end

    def test_stock_is_a_child_of_area_class
      assert_kind_of Area, @stock
    end

    def test_initial_stock_has_24_cards
      assert_equal 24, @stock.piles[0].size
    end

    def test_initial_stock_has_24_card_even_if_there_were_provided_more_cards
      deck = Deck.new
      stock = Stock.new(deck.shuffle_off! 52)
      assert_equal 24, @stock.piles[0].size
    end

    def test_stock_consists_of_1_pile
      assert_equal 1, @stock.piles.size
    end

    def test_overall_position_of_stock_can_be_gotten
      assert_equal Ray::Vector2[31, 23], @stock.pos
      assert_equal Ray::Vector2[31, 23], @stock.piles.first.pos
    end

    def test_stock_can_be_disposed_in_the_window
      @stock.send(:pos=, [0, 0])
      assert_equal Ray::Vector2[0, 0], @stock.pos
      @stock.send(:pos=, [200, 300])
      assert_equal Ray::Vector2[200, 300], @stock.pos
    end

  end
end
