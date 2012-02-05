require_relative 'helper'

module Patience
  class TestPile < MiniTest::Unit::TestCase

    def setup
      @cards = Array.new 10, Card.new(12, 3)
      @pile = Pile.new(@cards)
    end

    def test_pile_can_be_created
      assert Pile.new
    end

    def test_pile_is_an_instance_of_pile_class
      assert_instance_of Pile, @pile
    end

    def test_pile_accepts_only_one_argument
      assert_raises(ArgumentError) { Pile.new(@cards, 10) }
      assert_raises(ArgumentError) { Pile.new(@cards, @cards, 10) }
      assert Pile.new(@cards)
    end

    def test_pile_responds_to_instance_methods
      methods = [:cards, :background, :background=, :shuffle_off!, :<<, :pos=,
                 :last_card?, :draw_on, :hit?]
      methods.each { |method| assert_respond_to @pile, method }
    end

    def test_pile_responds_to_delegated_methods
      delegated_methods = [:size, :empty?, :pos, :x, :y]
      delegated_methods.each { |method| assert_respond_to @pile, method }
    end

    def test_pile_has_cards
      assert @pile.cards
    end

    def test_card_can_be_appended_to_the_pile
      pile = @pile.dup
      pile << Card.new(13, 3)
      assert_equal "Ace of Spades", pile.cards.last.to_s
      pile << Card.new(1, 4)
      assert_equal "Two of Clubs", pile.cards.last.to_s
    end

    def test_pile_has_background
      assert @pile.background
      assert_instance_of Ray::Sprite, @pile.background
    end

    def test_background_of_the_pile_can_be_changed
      pile = @pile.dup
      assert_equal Ray::Vector2[0, 0], pile.background.pos
      pile.background.pos = [200, 200]
      path = '../lib/patience/sprites/empty_stock.png'
      assert pile.background = Ray::Sprite.new(path_of(path))
      assert_equal Ray::Vector2[200, 200], pile.background.pos
    end

    def test_pile_has_position
      assert_equal [0, 0], @pile.pos.to_a
    end

    def test_position_of_a_pile_can_be_set
      pile = @pile.dup
      pile.pos = [105, 20]
      assert_equal [105, 20], pile.pos.to_a
    end

    def test_cards_can_be_counted_in_a_pile
      assert_equal 10, @pile.size
    end

    def test_cards_can_be_shuffled_off_from_a_pile
      pile = @pile.dup
      assert_equal 6, pile.shuffle_off!(6).size
      assert_equal 4, pile.size
    end

    def test_piles_last_card_detects_correctly
      assert @pile.last_card?(9)
    end

    def test_pile_can_tell_if_its_card_has_been_clicked
      # Pile with cards.
      pile = @pile.dup
      assert pile.hit?(Ray::Vector2[20, 20])
      refute pile.hit?(Ray::Vector2[1000, 0])

      # Empty pile.
      pile = Pile.new
      assert pile.hit?(Ray::Vector2[20, 20])
      refute pile.hit?(Ray::Vector2[1000, 0])
    end

  end
end
