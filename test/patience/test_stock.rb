require_relative 'helper'

module Patience
  class TestStockArea < TestCase

    def setup
      @deck = Deck.new
      @deck.cards.shuffle!
      @stock = Stock.new(@deck.shuffle_off! 24)
    end

    test 'Stock is a child of Area' do
      assert_kind_of Area, @stock
    end

    test 'Initial Stock has 24 cards' do
      assert_equal 24, @stock.piles[0].size
    end

    test 'Initial Stock has 24 cards, even if there were provided more cards' do
      deck = Deck.new
      stock = Stock.new(deck.shuffle_off! 52)
      assert_equal 24, @stock.piles[0].size
    end

    test 'Stock consists of one pile' do
      assert_equal 1, @stock.piles.size
    end

    test 'The overall position of Stock can be gotten' do
      assert_equal Ray::Vector2[31, 27], @stock.pos
      assert_equal Ray::Vector2[31, 27], @stock.piles.first.pos
    end

    test 'Stock can be disposed in the window' do
      @stock.send(:pos=, [0, 0])
      assert_equal Ray::Vector2[0, 0], @stock.pos
      @stock.send(:pos=, [200, 300])
      assert_equal Ray::Vector2[200, 300], @stock.pos
    end

  end
end
