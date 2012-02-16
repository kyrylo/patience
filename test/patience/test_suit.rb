require_relative 'helper'

module Patience
  class TestCardSuit < TestCase

    def setup
      @suits = %w[Heart Diamond Spade Club]
      @suit = Patience::Card::Suit::Diamond.new
    end

    test 'All suits do exist' do
      @suits.each do |suit|
        assert "Patience::Card::Suit::#{suit}".constantize.new
      end
    end

    test 'Suits are kind of Suit' do
      @suits.each do |suit|
        assert_kind_of Patience::Card::Suit,
                      "Patience::Card::Suit::#{suit}".constantize.new
      end
    end

    test 'A suit can be represented as Fixnum' do
      @suits.each_with_index do |suit, i|
        assert_equal i+1, "Patience::Card::Suit::#{suit}".constantize.new
      end
    end

    test 'A suit can be represented as String' do
      @suits.each do |suit|
        assert_equal suit+'s',
                     "Patience::Card::Suit::#{suit}".constantize.new.to_s
      end
    end

    test 'The Heart suit is red' do
      assert Patience::Card::Suit::Heart.new.red?
      refute Patience::Card::Suit::Heart.new.black?
    end

    test 'The Diamond suit is red' do
      assert Patience::Card::Suit::Diamond.new.red?
      refute Patience::Card::Suit::Diamond.new.black?
    end

    test 'The Spade suit is black' do
      assert Patience::Card::Suit::Spade.new.black?
      refute Patience::Card::Suit::Spade.new.red?
    end

    test 'The Club suit is black' do
      assert Patience::Card::Suit::Club.new.black?
      refute Patience::Card::Suit::Club.new.red?
    end

    test 'Suits can be compared to each other' do
      spades = Patience::Card::Suit::Spade.new
      hearts = Patience::Card::Suit::Heart.new
      diamonds1 = Patience::Card::Suit::Diamond.new
      diamonds2 = Patience::Card::Suit::Diamond.new

      refute spades == hearts
      assert spades != hearts
      assert diamonds1 == diamonds2
    end

    test "Suits can be checked, if they're of the same color" do
      red_suit = Patience::Card::Suit::Heart.new
      black_suit = Patience::Card::Suit::Spade.new
      assert @suit.same_color?(red_suit)
      assert red_suit.same_color?(@suit)
      refute @suit.same_color?(black_suit)
      refute black_suit.same_color?(@suit)
    end

    test "Suits can be checked, if they're of the different colors" do
      red_suit = Patience::Card::Suit::Heart.new
      black_suit = Patience::Card::Suit::Spade.new
      refute @suit.different_color?(red_suit)
      refute red_suit.different_color?(@suit)
      assert @suit.different_color?(black_suit)
      assert black_suit.different_color?(@suit)
    end

  end
end
