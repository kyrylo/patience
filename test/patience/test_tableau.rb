require_relative 'helper'

module Patience
  class TestTableauArea < MiniTest::Unit::TestCase

    def setup
      @deck = Deck.new
      @tableau = Tableau.new(@deck.shuffle_off! 28)
    end

    def test_tableau_is_a_child_of_area_class
      assert_kind_of Area, @tableau
    end

    def test_initial_tableau_has_28_cards
      cards = @tableau.piles.inject([]) { |cards, pile| cards << pile.cards }
      assert_equal 28, cards.flatten.size
    end

    # Test, that initial tableau pile contains N+1 cards,
    # where N is an index number of the pile, starting from 0.
    def test_initial_tableau_piles_have_correct_amount_of_cards
      @tableau.piles.each_with_index do |pile, i|
        assert_equal i+1, pile.size
      end
    end

    def test_overall_position_of_tableau_can_be_gotten
      assert_equal Ray::Vector2[31, 165], @tableau.pos
      assert_equal Ray::Vector2[31, 165], @tableau.piles.first.pos
    end

    def test_particular_position_of_a_pile_in_tableau_can_be_gotten
      assert_equal Ray::Vector2[141, 165], @tableau.piles[1].pos
      assert_equal Ray::Vector2[251, 165], @tableau.piles[2].pos
      assert_equal Ray::Vector2[691, 165], @tableau.piles.last.pos
    end

    def test_tableau_can_be_disposed_in_the_window
      @tableau.send(:pos=, [0, 0])
      assert_equal Ray::Vector2[0, 0],   @tableau.pos
      assert_equal Ray::Vector2[660, 0], @tableau.piles.last.pos
      @tableau.send(:pos=, [200, 300])
      assert_equal Ray::Vector2[200, 300], @tableau.pos
      assert_equal Ray::Vector2[860, 300], @tableau.piles.last.pos
    end

    def test_cards_in_tableau_have_a_margin_along_the_axis_Y
      assert_equal Ray::Vector2[31, 165], @tableau.piles[0].cards[0].pos
      assert_equal Ray::Vector2[251, 191], @tableau.piles[2].cards[1].pos
      assert_equal Ray::Vector2[471, 191], @tableau.piles[4].cards[1].pos
      assert_equal Ray::Vector2[581, 217], @tableau.piles[5].cards[2].pos
      assert_equal Ray::Vector2[691, 321], @tableau.piles.last.cards.last.pos
    end

  end
end
