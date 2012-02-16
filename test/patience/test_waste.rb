require_relative 'helper'

module Patience
  class TestWasteArea < TestCase

    def setup
      @waste = Waste.new
    end

    test 'Waste is a child of Area' do
      assert_kind_of Area, @waste
    end

    test 'Initial Waste has no cards' do
      assert_equal 0, @waste.piles[0].cards.size
    end

    test 'Waste consists of one pile' do
      assert_equal 1, @waste.piles.size
    end

    test 'Overall position of Waste can be gotten' do
      assert_equal Ray::Vector2[141, 23], @waste.pos
      assert_equal Ray::Vector2[141, 23], @waste.piles.first.pos
    end

    test 'Waste can be disposed in the window' do
      @waste.send(:pos=, [0, 0])
      assert_equal Ray::Vector2[0, 0], @waste.pos
      @waste.send(:pos=, [200, 300])
      assert_equal Ray::Vector2[200, 300], @waste.pos
    end

  end
end
