require_relative 'helper'

module Patience
  class TestProcessable < TestCase

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

    test 'Processable can select entity in areas by certain conditions' do
      assert_equal Tableau,
                   @dummy.detect_in(@areas, :area) { |area|
                     area.hit?(@mouse_pos_hit)
                   }.class
      assert_equal NilClass,
                   @dummy.detect_in(@areas, :area) { |area|
                     area.hit?(@mouse_pos_miss)
                   }.class

      assert_equal Pile,
                   @dummy.detect_in(@areas, :pile) { |pile|
                     pile.hit?(@mouse_pos_hit)
                   }.class
      assert_equal NilClass,
                   @dummy.detect_in(@areas, :pile) { |pile|
                     pile.hit?(@mouse_pos_miss)
                   }.class

      assert_equal Card,
                   @dummy.detect_in(@areas, :card) { |card|
                     card.hit?(@mouse_pos_hit)
                   }.class
      assert_equal NilClass,
                   @dummy.detect_in(@areas, :card) { |card|
                     card.hit?(@mouse_pos_miss)
                   }.class

      assert_raises(ArgumentError) do
        @dummy.detect_in(@areas, :cake)  { |cake| cake.hit?(@mouse_pos_miss) }
        @dummy.detect_in(@areas, :yadda) { |blah| blah.hit?(@mouse_pos_hit) }
      end
    end

    test 'Processable can find an area' do
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

    test 'Processable can find a pile' do
      assert_equal Pile, @dummy.find_pile_in(@areas) { |pile|
                           pile.hit?(@mouse_pos_hit) && @hit_pile = pile
                         }.class
      assert @areas[:tableau].piles.include?(@hit_pile)
      assert_equal NilClass, @dummy.find_pile_in(@areas) { |pile|
                               pile.hit?(@mouse_pos_miss)
                             }.class
    end

    test 'Processable can find a card' do
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

    test 'Processable can represent data as array' do
      assert_equal [nil, nil, nil], @dummy.to_a
      @dummy.find_all(@areas, @mouse_pos_hit)
      refute_nil @dummy.to_a.compact
      assert_instance_of Tableau, @dummy.to_a.first
      assert_kind_of     Area,    @dummy.to_a.first
      assert_instance_of Pile,    @dummy.to_a[1]
      assert_instance_of Card,    @dummy.to_a.last
    end

    test 'Processable can represent data as hash' do
      assert_equal({ :area => nil, :pile => nil, :card => nil }, @dummy.to_h)
      @dummy.find_all(@areas, @mouse_pos_hit)
      refute_nil @dummy.to_h
      assert_instance_of Tableau, @dummy.to_h[:area]
      assert_kind_of     Area,    @dummy.to_h[:area]
      assert_instance_of Pile,    @dummy.to_h[:pile]
      assert_instance_of Card,    @dummy.to_h[:card]
    end

    test 'Processable can check for data existence' do
      refute @dummy.something?
      @dummy.find_all(@areas, @mouse_pos_hit)
      assert @dummy.something?
    end

    test 'Processable can check for data abscence' do
      assert @dummy.nothing?
      @dummy.find_all(@areas, @mouse_pos_hit)
      refute @dummy.nothing?
    end

    test 'Processable can count an offset' do
      @dummy.find_all(@areas, @mouse_pos_hit)
      assert_equal Ray::Vector2[-1, -1],
                   @dummy.pick_up(@areas[:tableau].cards[0], @mouse_pos_hit)
    end

    test 'Processable can check, if Stock has been hit' do
      @dummy.find_all(@areas, Ray::Vector2[40, 40])
      assert @dummy.stock?
    end

    test 'Processable can check, if Waste has been hit' do
      @dummy.find_all(@areas, Ray::Vector2[160, 40])
      assert @dummy.waste?
    end

    test 'Processable can check, if Tableau has been hit' do
      @dummy.find_all(@areas, Ray::Vector2[32, 166])
      assert @dummy.tableau?
    end

    test 'Processable can check, if Foundation has been hit' do
      @dummy.find_all(@areas, Ray::Vector2[590, 40])
      assert @dummy.foundation?
    end

  end
end
