require_relative 'helper'

module Patience
  class TestArea < TestCase

    def setup
      @area = Area.new
      @cards = [Card.new(1, 1)]
    end

    test 'A new area should contain at least one pile' do
      assert_equal 1, Area.new.piles.size
    end

    test 'An area can contain several piles' do
      assert_equal 1,   Area.new(@cards, 1).piles.size
      assert_equal 10,  Area.new(@cards, 10).piles.size
      assert_equal 100, Area.new(@cards, 100).piles.size
    end

    test 'An area can return array of the piles' do
      assert_instance_of Array, @area.piles
      assert_instance_of Pile,  @area.piles.first
    end

    test 'An area can be disposed' do
      assert_equal Ray::Vector2[0, 0], @area.piles[0].pos
      @area.pos = [20, 20]
      assert_equal Ray::Vector2[20, 20], @area.piles[0].pos
      @area.pos = [-100, 20]
      assert_equal Ray::Vector2[-100, 20], @area.piles[0].pos

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

    test 'An area can tell its position' do
      assert_equal Ray::Vector2[0, 0], @area.pos
      @area.pos = [20, 20]
      assert_equal Ray::Vector2[20, 20], @area.pos
      @area.pos = [-100, 20]
      assert_equal Ray::Vector2[-100, 20], @area.pos
    end

    test 'An area can show all its cards' do
      assert_equal [], @area.cards
      @area.piles[0].cards << @cards
      assert_equal ["Ace of Hearts"], @area.cards.map(&:to_s)
    end

    test 'An area can tell, if its card has been clicked' do
      assert @area.hit?(Ray::Vector2[20, 20])
      refute @area.hit?(Ray::Vector2[1000, 0])
    end

    test 'A card can be added to the first pile of area from the given pile' do
      pile = Pile.new([Card.new(1, 1)])
      assert pile.cards.first.face_up?
      assert_equal 0, @area.cards.size
      @area.add_from(pile, pile.cards.first)
      assert_equal 1, @area.cards.size
      assert @area.cards.first.face_down?
      assert_instance_of Card, @area.cards.first
    end

  end
end
