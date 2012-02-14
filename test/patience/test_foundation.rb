require_relative 'helper'

module Patience
  class TestFoundationArea < MiniTest::Unit::TestCase

    def setup
      @foundation = Foundation.new
    end

    def test_initial_foundation_has_no_cards
      @foundation.piles.each { |pile| assert_equal 0, pile.cards.size }
    end

    def test_overall_position_of_foundation_can_be_gotten
      assert_equal Ray::Vector2[361, 23], @foundation.pos
      assert_equal Ray::Vector2[361, 23], @foundation.piles.first.pos
    end

    def test_particular_position_of_a_pile_in_foundation_can_be_gotten
      assert_equal Ray::Vector2[471, 23], @foundation.piles[1].pos
      assert_equal Ray::Vector2[581, 23], @foundation.piles[2].pos
    end

    def test_foundation_can_be_disposed_in_the_window
      @foundation.send(:pos=, [0, 0])
      assert_equal Ray::Vector2[0, 0], @foundation.pos
      assert_equal Ray::Vector2[330, 0], @foundation.piles.last.pos
      @foundation.send(:pos=, [200, 300])
      assert_equal Ray::Vector2[200, 300], @foundation.pos
      assert_equal Ray::Vector2[530, 300], @foundation.piles.last.pos
    end

  end
end
