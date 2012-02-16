require_relative '../helper'

module Patience
  class TestDrop < TestCase

    class EventHandler::Click
      attr_accessor :mouse_pos
    end

    class Dummy < EventHandler::Drop
      attr_accessor :dropped_card, :pile_beneath, :card_beneath
    end

    def setup
      @mouse_pos = Ray::Vector2[361, 243]
      @deck = Deck.new
      @areas = { :tableau => Tableau.new(@deck.shuffle_off! 28),
                 :waste => Waste.new }
      @click = EventHandler::Click.new(@mouse_pos, @areas)
      @drop = Dummy.new(@click, @areas)
    end

    test 'Drop can find an area beneath' do
      @drop.dropped_card.pos = Ray::Vector2[0, 0]
      assert_nil @drop.send(:find_area_beneath)
      @drop.dropped_card.pos = Ray::Vector2[252, 218]
      assert_nil @drop.send(:find_area_beneath)
      @drop.dropped_card.pos = Ray::Vector2[472, 270]
      assert_equal Tableau, @drop.send(:find_area_beneath).class
      assert_kind_of Area, @drop.send(:find_area_beneath)
    end

    test 'Drop can find a pile beneath' do
      @drop.dropped_card.pos = Ray::Vector2[0, 0]
      assert_nil @drop.send(:find_pile_beneath)
      @drop.dropped_card.pos = Ray::Vector2[252, 218]
      assert_nil @drop.send(:find_pile_beneath)
      @drop.dropped_card.pos = Ray::Vector2[472, 270]
      @drop.card_beneath = @drop.send(:find_card_beneath)
      assert_equal Pile, @drop.send(:find_pile_beneath).class
    end

    test 'Drop can find a card beneath' do
      @drop.dropped_card.pos = Ray::Vector2[0, 0]
      assert_nil @drop.send(:find_card_beneath)
      @drop.dropped_card.pos = Ray::Vector2[252, 218]
      assert_nil @drop.send(:find_card_beneath)
      @drop.dropped_card.pos = Ray::Vector2[472, 270]
      assert_equal Card, @drop.send(:find_card_beneath).class
    end

    test 'Drop can check if a card is operative' do
      @drop.dropped_card.pos = Ray::Vector2[0, 0]
      refute @drop.send(:operative?, @click.card)
      @drop.dropped_card.pos = Ray::Vector2[252, 218]
      refute @drop.send(:operative?, @click.card)
      @drop.dropped_card.pos = Ray::Vector2[472, 270]
      assert @drop.send(:operative?, @areas[:tableau].piles[4].cards.last)
    end

    test 'Drop can call off a card' do
      assert_equal Ray::Vector2[361, 243], @drop.dropped_card.pos
      @drop.dropped_card.pos = Ray::Vector2[0, 0]
      assert_equal Ray::Vector2[0, 0], @drop.dropped_card.pos
      @drop.send(:call_off)
      assert_equal Ray::Vector2[361, 243], @drop.dropped_card.pos
    end

    test 'Drop can be checked for the meeting of rank conditions' do
      assert @drop.send(:meets_rank_conditions?, Card.new(4, 2))
      refute @drop.send(:meets_rank_conditions?, Card.new(5, 2))
      refute @drop.send(:meets_rank_conditions?, Card.new(3, 2))
    end

    test 'Drop can be checked for the meeting of suit conditions' do
      refute @drop.send(:meets_suit_conditions?, Card.new(10, 1))
      refute @drop.send(:meets_suit_conditions?, Card.new(10, 2))
      assert @drop.send(:meets_suit_conditions?, Card.new(10, 3))
      assert @drop.send(:meets_suit_conditions?, Card.new(10, 4))
    end

    test 'Drop can add a card to a pile' do
      @drop.dropped_card.face_down
      @drop.pile_beneath = @areas[:tableau].piles[4]
      @drop.card_beneath = @drop.pile_beneath.cards.last
      assert_equal Ray::Vector2[361, 243],
                   @areas[:tableau].piles[3].cards.last.pos
      assert_equal Ray::Vector2[471, 269],
                   @areas[:tableau].piles[4].cards.last.pos
      assert @areas[:tableau].piles[3].cards.last.eql? Card.new(3, 2)

      @drop.send(:put_in)
      assert_equal Ray::Vector2[361, 243],
                   @areas[:tableau].piles[3].cards.last.pos
      assert_equal Ray::Vector2[471, 269],
                   @areas[:tableau].piles[4].cards.last.pos
      assert @areas[:tableau].piles[3].cards.last.eql? Card.new(3, 2)
      refute @areas[:tableau].piles[4].cards.last.eql? Card.new(3, 2)

      @drop.dropped_card.face_up
      @drop.card_beneath = nil
      @drop.pile_beneath = nil
      assert_equal Ray::Vector2[361, 243],
                   @areas[:tableau].piles[3].cards.last.pos
      assert_equal Ray::Vector2[471, 269],
                   @areas[:tableau].piles[4].cards.last.pos
      assert @areas[:tableau].piles[3].cards.last.eql? Card.new(3, 2)

      @drop.send(:put_in)
      assert_equal Ray::Vector2[361, 243],
                   @areas[:tableau].piles[3].cards.last.pos
      assert_equal Ray::Vector2[471, 269],
                   @areas[:tableau].piles[4].cards.last.pos
      assert @areas[:tableau].piles[3].cards.last.eql? Card.new(3, 2)
      refute @areas[:tableau].piles[4].cards.last.eql? Card.new(3, 2)

      @drop.pile_beneath = @areas[:tableau].piles[4]
      @drop.card_beneath = @drop.pile_beneath.cards.last
      assert_equal Ray::Vector2[361, 243],
                   @areas[:tableau].piles[3].cards.last.pos
      assert_equal Ray::Vector2[471, 269],
                   @areas[:tableau].piles[4].cards.last.pos
      assert @areas[:tableau].piles[3].cards.last.eql? Card.new(3, 2)
      refute @areas[:tableau].piles[4].cards.last.eql? Card.new(3, 2)

      @drop.send(:put_in)
      assert_equal Ray::Vector2[361, 217],
                   @areas[:tableau].piles[3].cards.last.pos
      assert_equal Ray::Vector2[471, 289],
                   @areas[:tableau].piles[4].cards.last.pos
      refute @areas[:tableau].piles[3].cards.last.eql? Card.new(3, 2)
      assert @areas[:tableau].piles[4].cards.last.eql? Card.new(3, 2)
    end

  end
end
