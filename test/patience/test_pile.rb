require_relative 'helper'

module Patience
  class TestPile < TestCase

    def setup
      @cards = Array.new 10, Card.new(12, 3)
      @pile = Pile.new(@cards)
    end

    test 'A pile has cards' do
      assert @pile.cards
    end

    test 'A card can be appended to the pile' do
      @pile << Card.new(13, 3)
      assert_equal "Ace of Spades", @pile.cards.last.to_s
      @pile << Card.new(1, 4)
      assert_equal "Two of Clubs", @pile.cards.last.to_s
    end

    test 'A pile has background' do
      assert @pile.background
      assert_instance_of Ray::Sprite, @pile.background
    end

    test 'The background of a pile can be changed' do
      assert_equal Ray::Vector2[0, 0], @pile.background.pos
      @pile.background.pos = [200, 200]
      path = '../lib/patience/sprites/empty_stock.png'
      assert @pile.background = Ray::Sprite.new(path_of(path))
      assert_equal Ray::Vector2[200, 200], @pile.background.pos
    end

    test 'A pile has position' do
      assert_equal [0, 0], @pile.pos.to_a
    end

    test 'The position of a pile can be set' do
      @pile.pos = [105, 20]
      assert_equal [105, 20], @pile.pos.to_a
    end

    test 'Cards can be counted in a pile' do
      assert_equal 10, @pile.size
    end

    test 'Cards can be shuffled off from a pile' do
      assert_equal 6, @pile.shuffle_off!(6).size
      assert_equal 4, @pile.size
    end

    test "A pile's last card detects correctly" do
      assert @pile.last_card?(9)
    end

    test 'A pile can tell if its card has been clicked' do
      # Pile with cards.
      assert @pile.hit?(Ray::Vector2[20, 20])
      refute @pile.hit?(Ray::Vector2[1000, 0])

      # Empty pile.
      pile = Pile.new
      assert pile.hit?(Ray::Vector2[20, 20])
      refute pile.hit?(Ray::Vector2[1000, 0])
    end

  end
end
