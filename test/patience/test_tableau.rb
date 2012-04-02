require_relative 'helper'

module Patience
  class TestTableauArea < TestCase

    def setup
      @deck = Deck.new
      @tableau = Tableau.new(@deck.shuffle_off! 28)
    end

    test 'Tableau is a child of Area' do
      assert_kind_of Area, @tableau
    end

    test 'Initial Tableau has 28 cards' do
      cards = @tableau.piles.inject([]) { |cards, pile| cards << pile.cards }
      assert_equal 28, cards.flatten.size
    end

    # Test, that initial tableau pile contains N+1 cards,
    # where N is an index number of the pile, starting from 0.
    test 'Initial Tableau piles have correct amount of cards' do
      @tableau.piles.each_with_index do |pile, i|
        assert_equal i+1, pile.size
      end
    end

    test 'The overall position of Tableau can be gotten' do
      assert_equal Ray::Vector2[31, 175], @tableau.pos
      assert_equal Ray::Vector2[31, 175], @tableau.piles.first.pos
    end

    test 'Particular position of a pile in Tableau can be gotten' do
      assert_equal Ray::Vector2[141, 175], @tableau.piles[1].pos
      assert_equal Ray::Vector2[251, 175], @tableau.piles[2].pos
      assert_equal Ray::Vector2[691, 175], @tableau.piles.last.pos
    end

    test 'Tableau can be disposed in the window' do
      @tableau.send(:pos=, [0, 0])
      assert_equal Ray::Vector2[0, 0],   @tableau.pos
      assert_equal Ray::Vector2[660, 0], @tableau.piles.last.pos
      @tableau.send(:pos=, [200, 300])
      assert_equal Ray::Vector2[200, 300], @tableau.pos
      assert_equal Ray::Vector2[860, 300], @tableau.piles.last.pos
    end

    test 'Cards in Tableau have a margin along the Y axis' do
      assert_equal Ray::Vector2[31, 175], @tableau.piles[0].cards[0].pos
      assert_equal Ray::Vector2[251, 185], @tableau.piles[2].cards[1].pos
      assert_equal Ray::Vector2[471, 185], @tableau.piles[4].cards[1].pos
      assert_equal Ray::Vector2[581, 195], @tableau.piles[5].cards[2].pos
      assert_equal Ray::Vector2[691, 235], @tableau.piles.last.cards.last.pos
    end

  end
end
