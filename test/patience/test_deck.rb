require_relative 'helper'

module Patience
  class TestDeck < TestCase

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

    test 'Initial size of a deck should be equal to 52' do
      assert_equal 52, @deck.size
    end

    (2..10).each do |n|
      define_method "test_initial_deck_has_#{n}_of_each_suit" do
        assert_deck_includes_all_suits_of n
      end
    end

    test 'Initial deck has jacks of each suit' do
      assert_deck_includes_all_suits_of 'Jack'
    end

    test 'Initial deck has queens of each suit' do
      assert_deck_includes_all_suits_of 'Queen'
    end

    test 'Initial deck has kings of each suit' do
      assert_deck_includes_all_suits_of 'King'
    end

    test 'Initial deck has aces of each suit' do
      assert_deck_includes_all_suits_of 'Ace'
    end

    test 'Cards of a deck can be accessed via their positon in the deck' do
      assert_equal 'Ace of Spades',   @cards[50].to_s
      assert_equal 'Two of Clubs',    @cards[3].to_s
      assert_equal 'Ten of Diamonds', @cards[33].to_s
      assert_equal 'Jack of Hearts',  @cards[36].to_s
    end

  end
end
