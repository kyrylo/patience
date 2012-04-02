require_relative 'helper'

module Patience
  class TestFoundationArea < TestCase

    def setup
      @foundation = Foundation.new
    end

    test 'Foundation is a child of Area' do
      assert_kind_of Area, @foundation
    end

    test 'Initial foundation has no cards' do
      @foundation.piles.each { |pile| assert_equal 0, pile.cards.size }
    end

    test 'Overall position of foundation can be gotten' do
      assert_equal Ray::Vector2[356, 23], @foundation.pos
      assert_equal Ray::Vector2[356, 23], @foundation.piles.first.pos
    end

    test 'Particular position of a pile in foundation can be gotten' do
      assert_equal Ray::Vector2[466, 23], @foundation.piles[1].pos
      assert_equal Ray::Vector2[576, 23], @foundation.piles[2].pos
    end

    test 'Foundation can be disposed in the window' do
      @foundation.send(:pos=, [0, 0])
      assert_equal Ray::Vector2[0, 0], @foundation.pos
      assert_equal Ray::Vector2[330, 0], @foundation.piles.last.pos
      @foundation.send(:pos=, [200, 300])
      assert_equal Ray::Vector2[200, 300], @foundation.pos
      assert_equal Ray::Vector2[530, 300], @foundation.piles.last.pos
    end

  end
end
