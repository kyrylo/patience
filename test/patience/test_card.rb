require_relative 'helper'

module Patience
  class TestCard < MiniTest::Unit::TestCase

    def setup
      @card = Card.new(13, 3)
      @ranks = %w[Two Three Four Five Six Seven Eight
               Nine Ten Jack Queen King Ace].map { |rank|
                 "Patience::Card::Rank::#{rank}".constantize
               }
      @suits = %w[Heart Diamond Spade Club].map { |suit|
        "Patience::Card::Suit::#{suit}".constantize
      }
    end

    def test_card_is_an_instance_of_card_class
      assert_instance_of Card, @card
    end

    def test_card_class_accepts_only_two_arguments
      assert_raises(ArgumentError) { Card.new(1) }
      assert_raises(ArgumentError) { Card.new(1, 1, 10) }
      assert_raises(ArgumentError) { Card.new }
    end

    def test_card_accepts_only_valid_ranks
      @ranks.size.times { |i| assert Card.new(i+1, 1) }
      assert_raises(Card::DefunctRank) { Card.new(0, 1)   }
      assert_raises(Card::DefunctRank) { Card.new(14, 2)  }
      assert_raises(Card::DefunctRank) { Card.new(-5, 3)  }
      assert_raises(Card::DefunctRank) { Card.new(114, 2) }
    end

    def test_card_accepts_only_valid_suits
      @suits.size.times { |i| assert Card.new(13, i+1) }
      assert_raises(Card::DefunctSuit) { Card.new(6, 0)  }
      assert_raises(Card::DefunctSuit) { Card.new(11, 5)  }
      assert_raises(Card::DefunctSuit) { Card.new(10, -3) }
      assert_raises(Card::DefunctSuit) { Card.new(8, 144) }
    end

    def test_card_has_rank
      assert_respond_to @card, :rank
    end

    def test_card_rank_can_be_represented_as_integer
      assert_equal 4,  Card.new(4, 2).rank.to_i
      assert_equal 1,  Card.new(1, 2).rank.to_i
      assert_equal 13, Card.new(13, 2).rank.to_i
    end

    def test_card_rank_can_be_represented_as_string
      assert_equal "Ace", Card.new(13, 3).rank.to_s
      assert_equal "Two", Card.new(1, 4).rank.to_s
      assert_equal "Six", Card.new(5, 2).rank.to_s
    end

    def test_card_has_suit
      assert_respond_to @card, :suit
    end

    def test_card_suit_can_be_represented_as_integer
      assert_equal 1, Card.new(4, 1).suit.to_i
      assert_equal 4, Card.new(1, 4).suit.to_i
      assert_equal 3, Card.new(13, 3).suit.to_i
    end

    def test_card_suit_can_be_represented_as_string
      assert_equal "Spades",   Card.new(13, 3).suit.to_s
      assert_equal "Clubs",    Card.new(1, 4).suit.to_s
      assert_equal "Diamonds", Card.new(5, 2).suit.to_s
    end

    def test_card_can_be_of_red_suit
      assert Card.new(5, 1).suit.red?
      assert Card.new(12, 2).suit.red?
      refute Card.new(12, 3).suit.red?
      refute Card.new(1, 4).suit.red?
    end

    def test_card_can_be_of_black_suit
      assert Card.new(2, 3).suit.black?
      assert Card.new(2, 4).suit.black?
      refute Card.new(10, 2).suit.black?
      refute Card.new(5, 1).suit.black?
    end

    def test_card_can_be_readable_by_human
      assert_equal "Ace of Spades",     @card.to_s
      assert_equal "Two of Hearts",     Card.new(1, 1).to_s
      assert_equal "Seven of Diamonds", Card.new(6, 2).to_s
    end

    def test_card_has_sprite
      assert_respond_to @card, :sprite
    end

    def test_cards_sprite_has_sheet_size
      assert_respond_to @card.sprite, :sheet_size
    end

    def test_cards_sprite_has_sheet_position
      assert_respond_to @card.sprite, :sheet_pos
    end

    def test_card_responds_to_delegated_methods
      delegated_methods = [:pos, :x, :y, :to_rect, :hit?, :overlaps?]
      delegated_methods.each { |method| assert_respond_to @card, method }
    end

    def test_card_can_turn_its_face_up
      assert @card.face_up
      assert_equal [13, 3], @card.face_up
    end

    def test_card_can_be_checked_if_it_has_been_turned_its_face_up
      assert @card.face_up?
      refute @card.face_down?
    end

    def test_card_can_turn_its_face_down
      assert @card.face_down
      assert_equal [0, 0], @card.face_down
    end

    def test_card_can_be_checked_if_it_has_been_turned_its_face_down
      @card.sprite.sheet_pos = [0, 0]
      assert @card.face_down?
      refute @card.face_up?
    end

    def test_cards_face_can_be_flipped
      assert @card.face_up?
      refute @card.face_down?

      @card.flip!
      assert @card.face_down?
      refute @card.face_up?

      @card.flip!
      assert @card.face_up?
      refute @card.face_down?
    end

  end
end
