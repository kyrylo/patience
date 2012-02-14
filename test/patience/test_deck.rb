require_relative 'helper'

module Patience
  class TestDeck < MiniTest::Unit::TestCase

    def setup
      @deck = Deck.new
      @cards = @deck.cards.map(&:to_s)
      @ranks = %w[Two Three Four Five Six Seven Eight Nine Ten]
      @suits = %w[Hearts Diamonds Spades Clubs]
    end

    def assert_deck_includes_all_suits_of(rank)
      rank = @ranks[rank-2] unless rank.instance_of? String
      @suits.each { |suit| assert_includes @cards, "#{rank} of #{suit}" }
    end

    def test_initial_size_of_deck_should_be_52
      assert_equal 52, @deck.size
    end

    (2..10).each do |n|
      define_method "test_initial_deck_has_#{n}_of_each_suit" do
        assert_deck_includes_all_suits_of n
      end
    end

    def test_initial_deck_has_jacks_of_each_suit
      assert_deck_includes_all_suits_of 'Jack'
    end

    def test_initial_deck_has_queens_of_each_suit
      assert_deck_includes_all_suits_of 'Queen'
    end

    def test_initial_deck_has_kings_of_each_suit
      assert_deck_includes_all_suits_of 'King'
    end

    def test_initial_deck_has_aces_of_each_suit
      assert_deck_includes_all_suits_of 'Ace'
    end

    def test_cards_of_a_deck_can_be_accessed_via_its_position_in_the_deck
      assert_equal 'Ace of Spades',   @cards[50].to_s
      assert_equal 'Two of Clubs',    @cards[3].to_s
      assert_equal 'Ten of Diamonds', @cards[33].to_s
      assert_equal 'Jack of Hearts',  @cards[36].to_s
    end

  end
end
