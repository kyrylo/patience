require_relative 'helper'

module Patience
  class TestWasteArea < MiniTest::Unit::TestCase

    def setup
      @waste = Waste.new
    end

    def test_waste_can_be_created
      assert Waste.new
    end

    def test_waste_is_an_instance_of_waste_class
      assert_instance_of Waste, @waste
    end

    def test_waste_is_a_child_of_area_class
      assert_kind_of Area, @waste
    end

    def test_waste_does_not_accept_arguments
      assert_raises(ArgumentError) { Waste.new(nil) }
      assert_raises(ArgumentError) { Waste.new(10, nil) }
    end

    def test_initial_waste_has_no_cards
      assert_equal 0, @waste.piles[0].cards.size
    end

    def test_waste_consists_of_1_pile
      assert_equal 1, @waste.piles.size
    end

    def test_overall_position_of_waste_can_be_gotten
      assert_equal Ray::Vector2[141, 23], @waste.pos
      assert_equal Ray::Vector2[141, 23], @waste.piles.first.pos
    end

    def test_waste_can_be_disposed_in_the_window
      waste = @waste.dup
      waste.send(:pos=, [0, 0])
      assert_equal Ray::Vector2[0, 0],   waste.pos
      waste.send(:pos=, [200, 300])
      assert_equal Ray::Vector2[200, 300], waste.pos
    end

  end
end
