require_relative 'helper'

module Patience
  class TestCardSuit < MiniTest::Unit::TestCase

    def setup
      @suits = %w[Heart Diamond Spade Club]
      @suit_object = Patience::Card::Suit::Diamond.new
    end

    def test_all_suits_exist
      @suits.each do |suit|
        assert "Patience::Card::Suit::#{suit}".constantize.new
      end
    end

    def test_suits_are_kind_of_suit_class
      @suits.each do |suit|
        assert_kind_of Patience::Card::Suit,
                      "Patience::Card::Suit::#{suit}".constantize.new
      end
    end

    def test_suit_has_integer_alias
      @suits.each_with_index do |suit, i|
        assert_equal i+1, "Patience::Card::Suit::#{suit}".constantize.new
      end
    end

    def test_suit_has_string_alias
      @suits.each do |suit|
        assert_equal suit+'s',
                     "Patience::Card::Suit::#{suit}".constantize.new.to_s
      end
    end

    def test_hearts_is_red
      assert Patience::Card::Suit::Heart.new.red?
      refute Patience::Card::Suit::Heart.new.black?
    end

    def test_diamonds_is_red
      assert Patience::Card::Suit::Diamond.new.red?
      refute Patience::Card::Suit::Diamond.new.black?
    end

    def test_spades_is_black
      assert Patience::Card::Suit::Spade.new.black?
      refute Patience::Card::Suit::Spade.new.red?
    end

    def test_clubs_is_black
      assert Patience::Card::Suit::Club.new.black?
      refute Patience::Card::Suit::Club.new.red?
    end

    def test_suits_can_be_compared_to_each_other
      spades = Patience::Card::Suit::Spade.new
      hearts = Patience::Card::Suit::Heart.new
      diamonds1 = Patience::Card::Suit::Diamond.new
      diamonds2 = Patience::Card::Suit::Diamond.new

      refute spades == hearts
      assert spades != hearts
      assert diamonds1 == diamonds2
    end

  end
end
