require_relative 'helper'

module Patience
  class TestCard < TestCase

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

    test 'A card accepts only valid ranks' do
      @ranks.size.times { |i| assert Card.new(i+1, 1) }
      assert_raises(Card::DefunctRank) { Card.new(0, 1)   }
      assert_raises(Card::DefunctRank) { Card.new(14, 2)  }
      assert_raises(Card::DefunctRank) { Card.new(-5, 3)  }
      assert_raises(Card::DefunctRank) { Card.new(114, 2) }
    end

    test 'A card accepts only valid suits' do
      @suits.size.times { |i| assert Card.new(13, i+1) }
      assert_raises(Card::DefunctSuit) { Card.new(6, 0)  }
      assert_raises(Card::DefunctSuit) { Card.new(11, 5)  }
      assert_raises(Card::DefunctSuit) { Card.new(10, -3) }
      assert_raises(Card::DefunctSuit) { Card.new(8, 144) }
    end

    test 'A card has rank' do
      assert_respond_to @card, :rank
    end

    test 'A card rank can be represented as integer' do
      assert_equal 4,  Card.new(4, 2).rank.to_i
      assert_equal 1,  Card.new(1, 2).rank.to_i
      assert_equal 13, Card.new(13, 2).rank.to_i
    end

    test 'A card rank can be represented as string' do
      assert_equal "Ace", Card.new(13, 3).rank.to_s
      assert_equal "Two", Card.new(1, 4).rank.to_s
      assert_equal "Six", Card.new(5, 2).rank.to_s
    end

    test 'A card has suit' do
      assert_respond_to @card, :suit
    end

    test 'A card suit can be represented as integer' do
      assert_equal 1, Card.new(4, 1).suit.to_i
      assert_equal 4, Card.new(1, 4).suit.to_i
      assert_equal 3, Card.new(13, 3).suit.to_i
    end

    test 'A card suit can be represented as string' do
      assert_equal "Spades",   Card.new(13, 3).suit.to_s
      assert_equal "Clubs",    Card.new(1, 4).suit.to_s
      assert_equal "Diamonds", Card.new(5, 2).suit.to_s
    end

    test 'A card can be of the red suit' do
      assert Card.new(5, 1).suit.red?
      assert Card.new(12, 2).suit.red?
      refute Card.new(12, 3).suit.red?
      refute Card.new(1, 4).suit.red?
    end

    test 'A card can be of the black suit' do
      assert Card.new(2, 3).suit.black?
      assert Card.new(2, 4).suit.black?
      refute Card.new(10, 2).suit.black?
      refute Card.new(5, 1).suit.black?
    end

    test 'A card can be readable by human' do
      assert_equal "Ace of Spades",     @card.to_s
      assert_equal "Two of Hearts",     Card.new(1, 1).to_s
      assert_equal "Seven of Diamonds", Card.new(6, 2).to_s
    end

    test 'A card has sprite' do
      assert_respond_to @card, :sprite
    end

    test "Card's sprite sheet has size" do
      assert_respond_to @card.sprite, :sheet_size
    end

    test "Card's sprite sheet has position" do
      assert_respond_to @card.sprite, :sheet_pos
    end

    test 'A card can turn its face upwards' do
      assert @card.face_up
      assert_equal [13, 3], @card.face_up
    end

    test 'A card can be checked, if its face looks upwards' do
      assert @card.face_up?
      refute @card.face_down?
    end

    test 'A card can turn its face downwards' do
      assert @card.face_down
      assert_equal [0, 0], @card.face_down
    end

    test 'A card can be checked, if its face looks downwards' do
      assert @card.face_down
      @card.sprite.sheet_pos = [0, 0]
      assert @card.face_down?
      refute @card.face_up?
    end

    test 'A card can be flipped' do
      assert @card.face_up?
      refute @card.face_down?

      @card.flip!
      assert @card.face_down?
      refute @card.face_up?

      @card.flip!
      assert @card.face_up?
      refute @card.face_down?
    end

    test 'A card can be checked for overlapping another card' do
      another_card = Card.new(10, 1)
      another_card.pos = Ray::Vector2[20, 20]
      assert @card.overlaps?(another_card)
      assert another_card.overlaps?(@card)

      another_card.pos = Ray::Vector2[200, 200]
      refute @card.overlaps?(another_card)
      refute another_card.overlaps?(@card)

      equal_card = Card.new(10, 1)
      equal_card.pos = Ray::Vector2[200, 200]
      assert_equal another_card.pos, equal_card.pos
      refute another_card.overlaps?(equal_card)
      refute equal_card.overlaps?(another_card)
    end

    test 'Cards can be checked for equality on the basis of ranks and suits' do
      same_card = Card.new(13, 3)
      only_same_rank = Card.new(13, 1)
      only_same_suit = Card.new(1, 3)
      not_same_at_all = Card.new(5, 4)

      assert @card.eql?(same_card)
      assert same_card.eql?(@card)
      refute @card.eql?(only_same_rank)
      refute @card.eql?(only_same_suit)
      refute only_same_suit.eql?(@card)
      refute @card.eql?(not_same_at_all)
      refute not_same_at_all.eql?(@card)
    end

  end
end
