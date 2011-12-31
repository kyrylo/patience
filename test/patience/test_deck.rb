require_relative 'helper'

module Patience
  class TestDeck < MiniTest::Unit::TestCase

    def setup
      @deck = Deck.new
      @cards = @deck.cards.map(&:to_s)
      @all_suits = ['hearts', 'diamonds', 'spades', 'clubs']
    end

    def assert_deck_includes_all_suits_of(rank)
      @all_suits.each { |suit| assert_includes @cards, "#{rank} of #{suit}" }
    end

    def test_deck_can_be_created
      assert_instance_of Deck, @deck
    end

    def test_initial_size_of_deck_should_be_52
      assert_equal 52, @deck.size
    end

    def test_initial_deck_has_deuces_of_each_suit
      assert_deck_includes_all_suits_of 2
    end

    def test_initial_deck_has_triples_of_each_suit
      assert_deck_includes_all_suits_of 3
    end

    def test_initial_deck_has_fours_of_each_suit
      assert_deck_includes_all_suits_of 4
    end

    def test_initial_deck_has_fives_of_each_suit
      assert_deck_includes_all_suits_of 5
    end

    def test_initial_deck_has_sixes_of_each_suit
      assert_deck_includes_all_suits_of 6
    end

    def test_initial_deck_has_sevens_of_each_suit
      assert_deck_includes_all_suits_of 7
    end

    def test_initial_deck_has_eights_of_each_suit
      assert_deck_includes_all_suits_of 8
    end

    def test_initial_deck_has_nines_of_each_suit
      assert_deck_includes_all_suits_of 9
    end

    def test_initial_deck_has_tens_of_each_suit
      assert_deck_includes_all_suits_of 10
    end

    def test_initial_deck_has_jacks_of_each_suit
      assert_deck_includes_all_suits_of 'jack'
    end

    def test_initial_deck_has_queens_of_each_suit
      assert_deck_includes_all_suits_of 'queen'
    end

    def test_initial_deck_has_kings_of_each_suit
      assert_deck_includes_all_suits_of 'king'
    end

    def test_initial_deck_has_aces_of_each_suit
      assert_deck_includes_all_suits_of 'ace'
    end

    def test_cards_of_a_deck_can_be_accessed_via_its_position_in_the_deck
      assert_equal 'ace of spades',  @cards[50]
      assert_equal '2 of clubs',     @cards[3]
      assert_equal '10 of diamonds', @cards[33]
      assert_equal 'jack of hearts', @cards[36]
    end

  end
end
