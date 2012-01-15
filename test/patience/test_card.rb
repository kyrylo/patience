require_relative 'helper'

module Patience
  class TestCard < MiniTest::Unit::TestCase

    class Rank
      def setup
        @ranks = %w[Two Three Four Five Six Seven
                    Eight Nine Ten Jack Queen King Ace]
        @rank_object = Rank::Five.new
      end

      def test_all_ranks_exist
        @ranks.each { |rank| assert "Rank::#{rank}".constantize.new }
      end

      def test_ranks_are_kind_of_rank_class
        @ranks.each do |rank|
          assert_kind_of "Rank::#{rank}".constantize.new, Rank
        end
      end

      def test_rank_object_responds_to_methods
        assert_respond_to @rank_object, :to_i
        assert_respond_to @rank_object, :to_s
      end

      def test_unreal_rank_cant_be_created
        assert_throws NameError, Rank::One.new
        assert_throws NameError, Rank::Eleven.new
        assert_throws NameError, Rank::Joker.new
      end

      def test_rank_has_integer_alias
        @ranks.each_with_index do |rank, i|
          assert_equal i+1, "Rank::#{rank}".constantize.new
        end
      end

      def test_rank_has_string_alias
        @ranks.each do |rank|
          assert_equal rank, "Rank::#{rank}".constantize.new.to_s
        end
      end
    end

    class Suit
      def setup
        @suits = %w[Heart Diamond Spade Club]
        @suit_object = Suit::Diamond.new
      end

      def test_all_suits_exist
        @suits.each { |suit| assert "Suit::#{suit}".constantize.new }
      end

      def test_suits_are_kind_of_suit_class
        @suits.each do |suit|
          assert_kind_of "Suit::#{suit}".constantize.new, Suit
        end
      end

      def test_suit_object_responds_to_methods
        assert_respond_to @suit_object, :red?
        assert_respond_to @suit_object, :black?
        assert_respond_to @suit_object, :to_i
        assert_respond_to @suit_object, :to_s
      end

      def test_suit_has_integer_alias
        @suits.each_with_index do |suit, i|
          assert_equal i+1, "Suit::#{suit}".constantize.new
        end
      end

      def test_suit_has_string_alias
        @suits.each do |suit|
          assert_equal suit, "Suit::#{suit}".constantize.new.to_s
        end
      end

      def test_hearts_is_red
        assert Suit::Heart.new.red?
        refute Suit::Heart.new.black?
      end

      def test_diamonds_is_red
        assert Suit::Diamond.new.red?
        refute Suit::Diamond.new.black?
      end

      def test_spades_is_black
        assert Suit::Spade.new.black?
        refute Suit::Spade.new.red?
      end

      def test_clubs_is_black
        assert Suit::Club.new.black?
        refute Suit::Club.new.red?
      end
    end

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

    def test_card_can_turn_its_face_up
      card = @card.dup
      assert card.face_up
      assert_equal [13, 3], card.face_up
    end

    def test_card_can_be_checked_if_it_has_been_turned_its_face_up
      card = @card.dup
      assert card.face_up?
      refute card.face_down?
    end

    def test_card_can_turn_its_face_down
      card = @card.dup
      assert card.face_down
      assert_equal [0, 0], card.face_down
    end

    def test_card_can_be_checked_if_it_has_been_turned_its_face_down
      card = @card.dup
      card.sprite.sheet_pos = [0, 0]
      assert card.face_down?
      refute card.face_up?
    end

    def test_cards_face_can_be_flipped
      card = @card.dup
      assert card.face_up?
      refute card.face_down?

      card.flip!
      assert card.face_down?
      refute card.face_up?

      card.flip!
      assert card.face_up?
      refute card.face_down?
    end

  end
end
