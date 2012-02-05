require_relative 'helper'

module Patience
  class TestProcessable < MiniTest::Unit::TestCase

    class Dummy
      include Processable
      attr_writer :areas, :mouse_pos
      Processable.areas = @areas
      Processable.mouse_pos = @mouse_pos
    end

    class DummyWithVariables < Dummy
      def find_all
        @area = find_area
        @pile = find_pile
        @card = find_card
      end
    end

    def setup
      @data = Dummy.new
      @data_wv = DummyWithVariables.new
      @mouse_pos_miss = Ray::Vector2[0, 0]
      @mouse_pos_hit = Ray::Vector2[32, 166]
      @deck = Deck.new
      @areas = { :tableau    => Tableau.new(@deck.shuffle_off! 28),
                 :stock      => Stock.new(@deck.shuffle_off! 24),
                 :waste      => Waste.new,
                 :foundation => Foundation.new }
      @data.areas = @areas
      @data_wv.areas = @areas
    end

    def test_processable_can_find_area
      dummy = Dummy.new
      refute @data.send(:find_area)

      refute @data.send(:find_area)
      @data.mouse_pos = @mouse_pos_miss
      refute @data.send(:find_area)
      @data.mouse_pos = @mouse_pos_hit
      assert @data.send(:find_area)
    end

    def test_processable_can_find_pile
      dummy = Dummy.new
      refute dummy.send(:find_pile)

      refute @data.send(:find_pile)
      @data.mouse_pos = @mouse_pos_miss
      refute @data.send(:find_pile)
      @data.mouse_pos = @mouse_pos_hit
      assert @data.send(:find_pile)
    end

    def test_processable_can_find_card
      dummy = Dummy.new
      refute dummy.send(:find_card)

      refute @data.send(:find_card)
      @data.mouse_pos = @mouse_pos_miss
      @data.mouse_pos = @mouse_pos_hit
      assert @data.send(:find_card)
    end

    def test_processable_can_represent_data_as_array
      @data_wv.mouse_pos = @mouse_pos_miss
      @data_wv.find_all
      assert_equal [nil, nil, nil], @data_wv.to_a
      @data_wv.mouse_pos = @mouse_pos_hit
      @data_wv.find_all
      refute_nil @data_wv.to_a.compact
      assert_instance_of Tableau, @data_wv.to_a.first
      assert_kind_of     Area,    @data_wv.to_a.first
      assert_instance_of Pile,    @data_wv.to_a[1]
      assert_instance_of Card,    @data_wv.to_a.last
    end

    def test_processable_can_represent_data_as_hash
      @data_wv.mouse_pos = @mouse_pos_miss
      @data_wv.find_all
      assert_equal({ :area => nil, :pile => nil, :card => nil }, @data_wv.to_h)
      @data_wv.mouse_pos = @mouse_pos_hit
      @data_wv.find_all
      refute_nil @data_wv.to_h
      assert_instance_of Tableau, @data_wv.to_h[:area]
      assert_kind_of     Area,    @data_wv.to_h[:area]
      assert_instance_of Pile,    @data_wv.to_h[:pile]
      assert_instance_of Card,    @data_wv.to_h[:card]
    end

    def test_processable_can_check_if_there_is_some_data
      @data_wv.mouse_pos = @mouse_pos_miss
      @data_wv.find_all
      refute @data_wv.something?
      @data_wv.mouse_pos = @mouse_pos_hit
      @data_wv.find_all
      assert @data_wv.something?
    end

    def test_processable_can_check_if_there_is_no_data
      @data_wv.mouse_pos = @mouse_pos_miss
      @data_wv.find_all
      assert @data_wv.nothing?
      @data_wv.mouse_pos = @mouse_pos_hit
      @data_wv.find_all
      refute @data_wv.nothing?
    end

    def test_processable_can_count_an_offset
      @data_wv.mouse_pos = @mouse_pos_miss
      @data_wv.find_all
      assert_nil @data_wv.pick_up
      @data_wv.mouse_pos = @mouse_pos_hit
      @data_wv.find_all
      assert_equal Ray::Vector2[-1, -1], @data_wv.pick_up
    end

    def test_processable_can_check_if_stock_was_hit
      @data_wv.mouse_pos = Ray::Vector2[40, 40]
      @data_wv.find_all
      assert @data_wv.stock?
    end

    def test_processable_can_check_if_waste_was_hit
      @data_wv.mouse_pos = Ray::Vector2[160, 40]
      @data_wv.find_all
      assert @data_wv.waste?
    end

    def test_processable_can_check_if_tableau_was_hit
      @data_wv.mouse_pos = Ray::Vector2[32, 166]
      @data_wv.find_all
      assert @data_wv.tableau?
    end

    def test_processable_can_check_if_foundation_was_hit
      @data_wv.mouse_pos = Ray::Vector2[590, 40]
      @data_wv.find_all
      assert @data_wv.foundation?
    end

    def test_data_processor_can_exempt_card_from_the_clicked_pile
      @data_wv.mouse_pos = @mouse_pos_miss
      @data_wv.find_all
      assert_raises(NoMethodError) { @data_wv.exempt(Card.new(1, 1)) }

      @data_wv.mouse_pos = @mouse_pos_hit
      @data_wv.find_all
      assert_equal 1, @data_wv.pile.size
      assert_equal "Two of Hearts", @data_wv.exempt(@data_wv.card).to_s
      assert_equal 0, @data_wv.pile.size
    end

  end
end
