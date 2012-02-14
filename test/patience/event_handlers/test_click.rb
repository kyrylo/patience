require_relative '../helper'

module Patience
  class TestClick < MiniTest::Unit::TestCase

    class Dummy < EventHandler::Click
      attr_accessor :area, :pile, :card

      def initialize(mouse_pos, areas)
        @mouse_pos = mouse_pos
        @areas = areas
      end
    end

    def setup
      @mouse_pos_missclick = Ray::Vector2[0, 0]
      @mouse_pos_hit = Ray::Vector2[32, 166]
      @deck = Deck.new
      @areas = { :tableau => Tableau.new(@deck.shuffle_off! 28),
                 :waste => Waste.new }
      @click_miss = EventHandler::Click.new(@mouse_pos_missclick, @areas)
      @click_hit  = EventHandler::Click.new(@mouse_pos_hit, @areas)
      @dummy_click_miss = Dummy.new(@mouse_pos_missclick, @areas)
      @dummy_click_hit  = Dummy.new(@mouse_pos_hit, @areas)
    end

    def test_click_can_select_area
      assert_nil @dummy_click_hit.area
      @dummy_click_hit.area = @dummy_click_hit.send(:select_area)
      assert_instance_of Tableau, @dummy_click_hit.area
      assert_kind_of     Area,    @dummy_click_hit.area

      assert_nil @dummy_click_miss.area
      @dummy_click_miss.area = @dummy_click_miss.send(:select_area)
      assert_nil @dummy_click_miss.area
    end

    def test_click_can_select_pile
      assert_nil @dummy_click_hit.pile
      @dummy_click_hit.pile = @dummy_click_hit.send(:select_pile)
      assert_instance_of Pile, @dummy_click_hit.pile

      assert_nil @dummy_click_miss.pile
      @dummy_click_miss.pile = @dummy_click_miss.send(:select_pile)
      assert_nil @dummy_click_miss.pile
    end

    def test_click_can_select_card
      assert_nil @dummy_click_hit.card
      @dummy_click_hit.card = @dummy_click_hit.send(:select_card)
      assert_instance_of Card, @dummy_click_hit.card

      assert_nil @dummy_click_miss.card
      @dummy_click_miss.card = @dummy_click_miss.send(:select_card)
      assert_nil @dummy_click_miss.card
    end


    # Test scenario code
    # ...

  end
end
