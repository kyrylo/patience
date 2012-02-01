require_relative 'helper'

module Patience
  class TestFoundationArea < MiniTest::Unit::TestCase

    def setup
      @foundation = Foundation.new
    end

    def test_foundation_can_be_created
      assert Foundation.new
    end

    def test_foundation_is_an_instance_of_foundation_class
      assert_instance_of Foundation, @foundation
    end

    def test_foundation_is_a_child_of_area_class
      assert_kind_of Area, @foundation
    end

    def test_foundation_does_not_accept_arguments
      assert_raises(ArgumentError) { Foundation.new(nil) }
      assert_raises(ArgumentError) { Foundation.new(10, nil) }
    end

    def test_foundation_responds_to_protected_instance_methods
      protected_methods = [:pos=]
      protected_methods.each { |method| assert_respond_to @foundation, method }
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
      foundation = @foundation.dup
      foundation.send(:pos=, [0, 0])
      assert_equal Ray::Vector2[0, 0],   foundation.pos
      assert_equal Ray::Vector2[330, 0], foundation.piles.last.pos
      foundation.send(:pos=, [200, 300])
      assert_equal Ray::Vector2[200, 300], foundation.pos
      assert_equal Ray::Vector2[530, 300], foundation.piles.last.pos
    end

  end
end
