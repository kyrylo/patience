require_relative 'helper'

module Patience
  class TestRank < MiniTest::Unit::TestCase

    def setup
      @ranks = %w[Two Three Four Five Six Seven
                  Eight Nine Ten Jack Queen King Ace]
      @rank = Card::Rank::Five.new
    end

    def test_all_ranks_exist
      @ranks.each do |rank|
        assert "Patience::Card::Rank::#{rank}".constantize.new
      end
    end

    def test_ranks_are_kind_of_rank_class
      @ranks.each do |rank|
        assert_kind_of Patience::Card::Rank,
                       "Patience::Card::Rank::#{rank}".constantize.new
      end
    end

    def test_unreal_rank_cant_be_created
      assert_raises(NameError) { Patience::Card::Rank::One.new }
      assert_raises(NameError) { Patience::Card::Rank::Eleven.new }
      assert_raises(NameError) { Patience::Card::Rank::Joker.new }
    end

    def test_rank_has_integer_alias
      @ranks.each_with_index do |rank, i|
        assert_equal i+1, "Patience::Card::Rank::#{rank}".constantize.new
      end
    end

    def test_rank_has_string_alias
      @ranks.each do |rank|
        assert_equal rank, "Patience::Card::Rank::#{rank}".constantize.new.to_s
      end
    end

    def test_ranks_can_be_compared_to_each_other
      ace = Patience::Card::Rank::Ace.new
      two = Patience::Card::Rank::Two.new
      ten1 = Patience::Card::Rank::Ten.new
      ten2 = Patience::Card::Rank::Ten.new

      assert ace > two
      refute ace < two
      refute ace == two
      assert ace != two
      assert ten1 == ten2
      refute ten1 > ten2
      refute ten1 < ten2
    end

    def test_rank_can_be_checked_if_it_is_higher_by_one_than_the_other_rank
      ace = Patience::Card::Rank::Ace.new
      four = Patience::Card::Rank::Four.new
      six = Patience::Card::Rank::Six.new

      assert @rank.higher_by_one_than?(four)
      refute four.higher_by_one_than?(@rank)
      refute @rank.higher_by_one_than?(ace)
      refute ace.higher_by_one_than?(@rank)
      refute @rank.higher_by_one_than?(six)
      assert six.higher_by_one_than?(@rank)
    end

  end
end
