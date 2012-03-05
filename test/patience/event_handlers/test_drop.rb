require_relative '../helper'

module Patience
  class TestDrop < TestCase

    class EventHandler::Click
      attr_accessor :mouse_pos
    end

    class Dummy < EventHandler::Drop
      attr_accessor :card_to_drop, :pile_beneath, :card_beneath, :area, :pile
    end

    def setup
      @mouse_pos = Ray::Vector2[361, 243]
      @deck      = Deck.new
      @areas     = { :tableau    => Tableau.new(@deck.shuffle_off! 28),
                     :waste      => Waste.new,
                     :foundation => Foundation.new }
      @click     = EventHandler::Click.new(@mouse_pos, @areas)
      @drop      = Dummy.new(@click, @areas)
    end

    def fill_attributes_up(drop)
      @drop.card_beneath = @drop.send(:find_card_beneath)
      @drop.pile_beneath = @drop.send(:find_pile_beneath)
    end

    test 'An area can be found by drop' do
      @drop.card_to_drop.pos = Ray::Vector2[0, 0]
      fill_attributes_up(@drop)

      assert_nil @drop.send(:find_area_beneath)

      @drop.card_to_drop.pos = Ray::Vector2[252, 218]
      fill_attributes_up(@drop)
      assert_nil @drop.send(:find_area_beneath)

      @drop.card_to_drop.pos = Ray::Vector2[472, 270]
      fill_attributes_up(@drop)
      assert_equal Tableau, @drop.send(:find_area_beneath).class

      assert_kind_of Area, @drop.send(:find_area_beneath)
    end

    test 'A pile can be found by drop' do
      @drop.card_to_drop.pos = Ray::Vector2[0, 0]
      assert_nil @drop.send(:find_pile_beneath)

      @drop.card_to_drop.pos = Ray::Vector2[252, 218]
      assert_nil @drop.send(:find_pile_beneath)

      @drop.card_to_drop.pos = Ray::Vector2[472, 270]
      @drop.card_beneath = @drop.send(:find_card_beneath)

      assert_equal Pile, @drop.send(:find_pile_beneath).class
    end

    test 'A card can be found by drop' do
      @drop.card_to_drop.pos = Ray::Vector2[0, 0]
      assert_nil @drop.send(:find_card_beneath)

      @drop.card_to_drop.pos = Ray::Vector2[252, 218]
      assert_nil @drop.send(:find_card_beneath)

      @drop.card_to_drop.pos = Ray::Vector2[472, 270]
      assert_equal Card, @drop.send(:find_card_beneath).class
    end

    test 'A drop can decide whether a card meets conditions of Tableau' do
      @drop.card_to_drop = Card.new(8, 1)
      nine_of_clubs    = Card.new(9, 4)
      king_of_diamonds = Card.new(13, 2)
      nine_of_hearts   = Card.new(9, 1)

      assert @drop.send(:tableau_conditions?, nine_of_clubs)
      refute @drop.send(:tableau_conditions?, king_of_diamonds)
      refute @drop.send(:tableau_conditions?, nine_of_hearts)
    end

    test 'A drop can decide whether a card meets conditions of Foundation' do
      @drop.card_to_drop = Card.new(10, 1)
      nine_of_clubs    = Card.new(9, 4)
      king_of_diamonds = Card.new(13, 2)
      nine_of_hearts   = Card.new(9, 1)

      refute @drop.send(:foundation_conditions?, nine_of_clubs)
      refute @drop.send(:foundation_conditions?, king_of_diamonds)
      assert @drop.send(:foundation_conditions?, nine_of_hearts)
    end

    test 'A dropped card can be called off' do
      assert_equal Ray::Vector2[361, 243], @drop.card_to_drop.pos

      @drop.card_to_drop.pos = Ray::Vector2[0, 0]
      assert_equal Ray::Vector2[0, 0], @drop.card_to_drop.pos

      @drop.send(:call_off)
      assert_equal Ray::Vector2[361, 243], @drop.card_to_drop.pos
    end

    test 'A dropped card can be added to the pile beneath' do
      @drop.pile_beneath = Pile.new
      @drop.pile = Pile.new([Card.new(1, 1)])

      assert_equal 0, @drop.pile_beneath.size
      assert_equal 1, @drop.pile.size

      @drop.send(:add_to_pile_beneath, @drop.pile.cards[0])
      assert_equal 1, @drop.pile_beneath.size
      assert_instance_of Card, @drop.pile_beneath.cards[0]
      assert_equal Card::Rank::Ace, @drop.pile_beneath.cards[0].rank.class
      assert_equal 0, @drop.pile.size
    end

    # Not complete.
    test "A dropped card can be checked, if it's allowed to be put in Tableau" do
      @drop.card_to_drop.pos = Ray::Vector2[472, 270]
      fill_attributes_up(@drop)
      assert @drop.send(:can_put_in_tableau?)

      @drop.card_to_drop = Card.new(1, 1)
      @drop.card_to_drop.pos = Ray::Vector2[472, 270]
      refute @drop.send(:can_put_in_tableau?)
    end

    # Not complete.
    test "A dropped card can be checked, if it's allowed to be put in Foundation" do
      @drop.card_to_drop = Card.new(1, 1)
      @drop.card_to_drop.pos = Ray::Vector2[362, 23]
      fill_attributes_up(@drop)
      assert @drop.send(:can_put_in_foundation?)

      @drop.card_to_drop = Card.new(10, 1)
      refute @drop.send(:can_put_in_foundation?)
    end

    test 'A dropped card can be put in Tableau' do
      @drop.card_to_drop.pos = Ray::Vector2[472, 270]
      fill_attributes_up(@drop)
      assert_equal 5, @areas[:tableau].piles[4].size
      @drop.send(:put_in_tableau)
      assert_equal 6, @areas[:tableau].piles[4].size

      @areas[:tableau].piles[3] << Card.new(2, 3)
      @areas[:tableau].piles[3].cards.last.pos = @mouse_pos
      @click = EventHandler::Click.new(@mouse_pos, @areas)
      @drop = Dummy.new(@click, @areas)
      @drop.card_to_drop.pos = Ray::Vector2[472, 270]
      fill_attributes_up(@drop)
      @drop.send(:put_in_tableau)
      assert_equal 7, @areas[:tableau].piles[4].size
    end

    test 'A dropped card can be put in Foundation' do
      @click = EventHandler::Click.new(Ray::Vector2[32, 165], @areas)
      @drop = Dummy.new(@click, @areas)
      @drop.card_to_drop.pos = Ray::Vector2[362, 23]
      fill_attributes_up(@drop)
      @drop.send(:put_in_foundation)
      assert_equal 1, @areas[:foundation].piles[0].size

      last_card = @areas[:tableau].piles[2].cards.last
      @areas[:tableau].piles[2].cards.delete(last_card)
      @areas[:tableau].piles[2].cards.last.flip!
      @click = EventHandler::Click.new(Ray::Vector2[252, 192], @areas)
      @drop = Dummy.new(@click, @areas)
      @drop.card_to_drop.pos = Ray::Vector2[362, 23]
      fill_attributes_up(@drop)
      @drop.send(:put_in_foundation)
      assert_equal 2, @areas[:foundation].piles[0].size
    end

  end
end
