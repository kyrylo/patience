require_relative 'helper'

module Patience
  class TestRank < TestCase

    def setup
      @ranks = %w[Two Three Four Five Six Seven
                  Eight Nine Ten Jack Queen King Ace]
      @rank = Card::Rank::Five.new
    end

    test 'All ranks do exist' do
      @ranks.each do |rank|
        assert "Patience::Card::Rank::#{rank}".constantize.new
      end
    end

    test 'Ranks are kind of Rank' do
      @ranks.each do |rank|
        assert_kind_of Patience::Card::Rank,
                       "Patience::Card::Rank::#{rank}".constantize.new
      end
    end

    test "Unreal rank can't be created" do
      assert_raises(NameError) { Patience::Card::Rank::One.new }
      assert_raises(NameError) { Patience::Card::Rank::Eleven.new }
      assert_raises(NameError) { Patience::Card::Rank::Joker.new }
    end

    test 'Rank can be represented as Fixnum' do
      @ranks.each_with_index do |rank, i|
        assert_equal i+1, "Patience::Card::Rank::#{rank}".constantize.new
      end
    end

    test 'Rank can be represented as String' do
      @ranks.each do |rank|
        assert_equal rank, "Patience::Card::Rank::#{rank}".constantize.new.to_s
      end
    end

    test 'Ranks can be compared to each other' do
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

    test "Rank can be checked, if it's higher by one, than the other rank" do
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
