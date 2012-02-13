require_relative 'helper'

module Patience
  class TestProcessable < MiniTest::Unit::TestCase

    class Dummy
      include Processable
      attr_accessor :area, :card, :pile

      def find_all(areas, mouse_pos)
        @area = find_area_in(areas) { |area| area.hit?(mouse_pos) }
        @pile = find_pile_in(areas) { |pile| pile.hit?(mouse_pos) }
        @card = find_card_in(areas) { |card| card.hit?(mouse_pos) }
      end
    end

    def setup
      @dummy = Dummy.new
      @mouse_pos_miss = Ray::Vector2[0, 0]
      @mouse_pos_hit = Ray::Vector2[32, 166]
      @deck = Deck.new
      @areas = { :tableau    => Tableau.new(@deck.shuffle_off! 28),
                 :stock      => Stock.new(@deck.shuffle_off! 24),
                 :waste      => Waste.new,
                 :foundation => Foundation.new }
    end

    def test_processable_has_getter_methods
      [:area, :pile, :card].each { |method| assert_respond_to @dummy, method }
    end

    def test_processable_can_select_in_areas_needed_entity_by_certain_conditions
      assert_equal Tableau, @dummy.select_in(@areas, :area) { |area|
                              area.hit?(@mouse_pos_hit)
                            }.class
      assert_equal NilClass, @dummy.select_in(@areas, :area) { |area|
                               area.hit?(@mouse_pos_miss)
                             }.class

      assert_equal Pile, @dummy.select_in(@areas, :pile) { |pile|
                           pile.hit?(@mouse_pos_hit)
                         }.class
      assert_equal NilClass, @dummy.select_in(@areas, :pile) { |pile|
                               pile.hit?(@mouse_pos_miss)
                             }.class

      assert_equal Card, @dummy.select_in(@areas, :card) { |card|
                           card.hit?(@mouse_pos_hit)
                         }.class
      assert_equal NilClass, @dummy.select_in(@areas, :card) { |card|
                               card.hit?(@mouse_pos_miss)
                             }.class

      assert_raises(ArgumentError) do
        @dummy.select_in(@areas, :cake)  { |cake| cake.hit?(@mouse_pos_miss) }
        @dummy.select_in(@areas, :yadda) { |blah| blah.hit?(@mouse_pos_hit) }
      end
    end

    def test_processable_can_find_area
      assert_equal Tableau, @dummy.find_area_in(@areas) { |area|
                              area.hit?(@mouse_pos_hit)
                            }.class
      mouse_pos_hit_stock = Ray::Vector2[31, 65]
      assert_equal Stock, @dummy.find_area_in(@areas) { |area|
                            area.hit?(mouse_pos_hit_stock)
                          }.class
      assert_equal NilClass, @dummy.find_area_in(@areas) { |area|
                               area.hit?(@mouse_pos_miss)
                             }.class
    end

    def test_processable_can_find_pile
      assert_equal Pile, @dummy.find_pile_in(@areas) { |pile|
                           pile.hit?(@mouse_pos_hit) && @hit_pile = pile
                         }.class
      assert @areas[:tableau].piles.include?(@hit_pile)
      assert_equal NilClass, @dummy.find_pile_in(@areas) { |pile|
                               pile.hit?(@mouse_pos_miss)
                             }.class
    end

    def test_processable_can_find_card
      mouse_pos_hit_stock = Ray::Vector2[31, 65]
      assert_equal Card, @dummy.find_card_in(@areas) { |card|
                           card.hit?(@mouse_pos_hit)
                         }.class
      assert_equal Card, @dummy.find_card_in(@areas) { |card|
                          card.hit?(mouse_pos_hit_stock) &&
                          @hit_card = card
                        }.class
      assert @areas[:stock].cards.include?(@hit_card)
      assert_equal NilClass, @dummy.find_card_in(@areas) { |card|
                               card.hit?(@mouse_pos_miss)
                             }.class
    end

    def test_processable_can_represent_data_as_array
      assert_equal [nil, nil, nil], @dummy.to_a
      @dummy.find_all(@areas, @mouse_pos_hit)
      refute_nil @dummy.to_a.compact
      assert_instance_of Tableau, @dummy.to_a.first
      assert_kind_of     Area,    @dummy.to_a.first
      assert_instance_of Pile,    @dummy.to_a[1]
      assert_instance_of Card,    @dummy.to_a.last
    end

    def test_processable_can_represent_data_as_hash
      assert_equal({ :area => nil, :pile => nil, :card => nil }, @dummy.to_h)
      @dummy.find_all(@areas, @mouse_pos_hit)
      refute_nil @dummy.to_h
      assert_instance_of Tableau, @dummy.to_h[:area]
      assert_kind_of     Area,    @dummy.to_h[:area]
      assert_instance_of Pile,    @dummy.to_h[:pile]
      assert_instance_of Card,    @dummy.to_h[:card]
    end

    def test_processable_can_check_if_there_is_some_data
      refute @dummy.something?
      @dummy.find_all(@areas, @mouse_pos_hit)
      assert @dummy.something?
    end

    def test_processable_can_check_if_there_is_no_data
      assert @dummy.nothing?
      @dummy.find_all(@areas, @mouse_pos_hit)
      refute @dummy.nothing?
    end

    def test_processable_can_count_an_offset
      @dummy.find_all(@areas, @mouse_pos_hit)
      assert_equal Ray::Vector2[-1, -1],
                   @dummy.pick_up(@areas[:tableau].cards[0], @mouse_pos_hit)
    end

    def test_processable_can_check_if_stock_was_hit
      @dummy.find_all(@areas, Ray::Vector2[40, 40])
      assert @dummy.stock?
    end

    def test_processable_can_check_if_waste_was_hit
      @dummy.find_all(@areas, Ray::Vector2[160, 40])
      assert @dummy.waste?
    end

    def test_processable_can_check_if_tableau_was_hit
      @dummy.find_all(@areas, Ray::Vector2[32, 166])
      assert @dummy.tableau?
    end

    def test_processable_can_check_if_foundation_was_hit
      @dummy.find_all(@areas, Ray::Vector2[590, 40])
      assert @dummy.foundation?
    end

    def test_processable_can_exempt_card_from_the_clicked_pile
      @dummy.find_all(@areas, @mouse_pos_miss)
      assert_raises(NoMethodError) { @dummy_wv.exempt(Card.new(1, 1)) }

      @dummy.find_all(@areas, @mouse_pos_hit)
      assert_equal 1, @dummy.pile.size
      assert_equal "Two of Hearts", @dummy.exempt(@dummy.card).to_s
      assert_equal 0, @dummy.pile.size
    end

  end
end
