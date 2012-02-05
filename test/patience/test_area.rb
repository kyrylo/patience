require_relative 'helper'

module Patience
  class TestArea < MiniTest::Unit::TestCase

    def setup
      @area = Area.new
      @cards = [Card.new(1, 1)]
    end

    def test_area_can_be_created
      assert Area.new
    end

    def test_area_is_an_instance_of_area_class
      assert_instance_of Area, @area
    end

    def test_area_accepts_two_arguments
      assert Area.new(@cards, 2)
      assert_raises(ArgumentError) { Area.new(@cards, 10, nil) }
    end

    def test_area_arguments_are_optional
      assert Area.new([], 22)
      assert Area.new(@cards)
    end

    def test_new_area_should_contain_at_least_one_pile
      assert_equal 1, Area.new.piles.size
    end

    def test_area_can_contain_several_piles
      assert_equal 1,   Area.new(@cards, 1).piles.size
      assert_equal 10,  Area.new(@cards, 10).piles.size
      assert_equal 100, Area.new(@cards, 100).piles.size
    end

    def test_area_responds_to_instance_methods
      methods = [:pos, :pos=, :draw_on, :cards, :hit?]
      methods.each { |method| assert_respond_to @area, method }
    end

    def test_area_can_return_array_of_the_piles
      assert_instance_of Array, @area.piles
      assert_instance_of Pile,  @area.piles.first
    end

    def test_area_can_be_disposed
      area = @area.dup
      assert_equal Ray::Vector2[0, 0], area.piles[0].pos
      area.pos = [20, 20]
      assert_equal Ray::Vector2[20, 20], area.piles[0].pos
      area.pos = [-100, 20]
      assert_equal Ray::Vector2[-100, 20], area.piles[0].pos

      area = Area.new([], 4)
      assert_equal Ray::Vector2[0, 0], area.piles[0].pos
      assert_equal Ray::Vector2[0, 0], area.piles[3].pos
      area.pos = [20, 20]
      assert_equal Ray::Vector2[20, 20], area.piles[0].pos
      assert_equal Ray::Vector2[20, 20], area.piles[3].pos
      area.pos = [-100, 20]
      assert_equal Ray::Vector2[-100, 20], area.piles[0].pos
      assert_equal Ray::Vector2[-100, 20], area.piles[3].pos
    end

    def test_area_can_tell_its_position
      area = @area.dup
      assert_equal Ray::Vector2[0, 0], area.pos
      area.pos = [20, 20]
      assert_equal Ray::Vector2[20, 20], area.pos
      area.pos = [-100, 20]
      assert_equal Ray::Vector2[-100, 20], area.pos
    end

    def test_area_can_show_all_its_cards
      area = @area.dup
      assert_equal [], area.cards
      area.piles[0].cards << @cards
      assert_equal ["Two of Hearts"], area.cards.map(&:to_s)
    end

    def test_area_can_tell_if_its_card_has_been_clicked
      area = @area.dup
      assert area.hit?(Ray::Vector2[20, 20])
      refute area.hit?(Ray::Vector2[1000, 0])
    end

  end
end
