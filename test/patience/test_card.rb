require_relative 'helper'

module Patience
  class TestCard < MiniTest::Unit::TestCase

    def setup
      @card = Card.new(12, 3)
      @ranks = [2, 3, 4, 5 ,6 ,7 ,8 ,9, 10, :jack, :queen, :king, :ace]
      @number_ranks  = @ranks.find_all { |r| r.kind_of? Integer }
      @supreme_ranks = @ranks.find_all { |r| r.kind_of? Symbol  }
      @suits = [:hearts, :diamonds, :spades, :clubs]
    end

    def test_card_is_an_instance_of_card_class
      assert_instance_of Card, @card, "@card isn't an instance of card class"
    end

    def test_card_class_accepts_two_arguments
      assert Card.new(1, 1)
      assert_raises(ArgumentError) { Card.new(1) }
      assert_raises(ArgumentError) { Card.new(1, 1, 10) }
      assert_raises(ArgumentError) { Card.new }
    end

    def test_ranks
      assert_equal 13, @ranks.size, "There are more or less than 13 ranks"
      assert_equal 2,  @number_ranks.min, "Minimum numeric rank isn't equal to 2"
      assert_equal 10, @number_ranks.max, "Maximum numeric rank isn't equal to 10"
      assert_equal @number_ranks.sort,
                   Card::RANKS.find_all { |r| r.kind_of? Integer }.sort
      assert_equal @supreme_ranks,
                   Card::RANKS.find_all { |r| r.kind_of? Symbol }
    end

    def test_suits
      assert_equal 4, @suits.size, "There are more or less than 4 suits"
      assert_equal @suits.sort, Card::SUITS.sort, "Suits are violated"
    end

    def test_card_has_rank
      assert_respond_to @card, :rank
    end

    def test_card_has_suit
      assert_respond_to @card, :suit
    end

    def test_card_has_rank_and_suit
      assert_equal "ace of spades", @card.to_s
    end

    def test_rank_should_be_number_or_symbol
      ranks = -> { Card::RANKS.map do |r|
                     r.kind_of? Integer or r.kind_of? Symbol or return
                   end }
      assert ranks.call, "One or more ranks isn't a number or a symbol"
    end

    def test_suit_should_be_symbol
      suits = -> { Card::SUITS.map { |s| s.kind_of? Symbol or return }}
      assert suits.call, "One or more suits isn't a symbol"
    end

    def test_card_has_sprite
      assert_respond_to @card, :sprite
    end

    def test_card_has_position_x
      assert_respond_to @card.sprite, :x
    end

    def test_card_has_position_y
      assert_respond_to @card.sprite, :y
    end

    def test_card_has_position
      assert_respond_to @card.sprite, :pos
    end

    def test_cards_sprite_has_sheet_size
      assert_respond_to @card.sprite, :sheet_size
    end

    def test_cards_sprite_has_sheet_position
      assert_respond_to @card.sprite, :sheet_pos
    end

    def test_card_can_be_of_red_suit
      assert Card.new(5, 1).red?
      assert Card.new(12, 2).red?
      refute Card.new(12, 3).red?
      refute Card.new(1, 4).red?
    end

    def test_card_can_be_of_black_suit
      assert Card.new(2, 3).black?
      assert Card.new(2, 4).black?
      refute Card.new(10, 2).black?
      refute Card.new(5, 1).black?
    end

  end
end
