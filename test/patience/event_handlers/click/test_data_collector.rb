require_relative '../../helper'

module Patience
  class TestClickDataCollector < MiniTest::Unit::TestCase

    def setup
      @mouse_pos_missclick = Ray::Vector2[0, 0]
      @mouse_pos_hit = Ray::Vector2[32, 166]
      @deck = Deck.new
      @areas = { :tableau => Tableau.new(@deck.shuffle_off! 28),
                 :waste => Waste.new }
      @data_miss = EventHandler::Click::DataCollector.new(@mouse_pos_missclick,
                                                          @areas)
      @data_exist = EventHandler::Click::DataCollector.new(@mouse_pos_hit,
                                                           @areas)
    end

    def test_data_collector_can_be_created
      assert EventHandler::Click::DataCollector.new(@mouse_pos_hit, @areas)
    end

    def test_data_collector_is_an_instance_of_data_collector_class
      assert_instance_of EventHandler::Click::DataCollector, @data_miss
    end

    def test_data_collector_accepts_two_arguments
      assert_raises(ArgumentError) do
        EventHandler::Click::DataCollector.new
      end

      assert_raises(ArgumentError) do
        EventHandler::Click::DataCollector.new(@mouse_pos_miss)
      end

      assert_raises(ArgumentError) do
        EventHandler::Click::DataCollector.new(@mouse_pos_miss, @area, 10)
      end
    end

    def test_data_collector_responds_to_instance_methods
      methods = [:mouse_pos, :area, :pile, :card, :gather!, :to_h, :to_a, :to_s]
      methods.each { |method| assert_respond_to @data_miss, method }
    end

    def test_data_collector_responds_to_protected_methods
      protected_methods = [:find_all, :find_pile]
      protected_methods.each { |method| assert_respond_to @data_miss, method }
    end

    def test_data_collector_can_gather_data
      data = @data_miss.dup
      [:area, :pile, :card].each { |method| assert_nil data.send(method) }

      data = @data_exist.dup
      data.gather!
      [:area, :pile, :card].each { |method| refute_nil data.send(method) }

      mouse_pos = Ray::Vector2[142, 24]
      data = EventHandler::Click::DataCollector.new(mouse_pos, @areas)
      [:area, :pile, :card].each { |method| assert_nil data.send(method) }
      data.gather!
      [:area, :pile].each { |method| refute_nil data.send(method) }
      assert_nil data.card
    end

    def test_data_collector_can_represent_data_as_hash
      data = @data_miss.dup
      assert_equal({ :area => nil, :pile => nil, :card => nil }, data.to_h)
      data.gather!
      assert_equal({ :area => nil, :pile => nil, :card => nil }, data.to_h)

      data = @data_exist.dup
      assert_equal({ :area => nil, :pile => nil, :card => nil }, data.to_h)
      data.gather!
      refute_nil data.to_h
      assert_instance_of Tableau, data.to_h[:area]
      assert_instance_of Pile,    data.to_h[:pile]
      assert_instance_of Card,    data.to_h[:card]
    end

    def test_data_collector_can_represent_data_as_array
      data = @data_miss.dup
      assert_equal [nil, nil, nil], data.to_a
      data.gather!
      assert_equal [nil, nil, nil], data.to_a

      data = @data_exist.dup
      assert_equal [nil, nil, nil], data.to_a
      data.gather!
      refute_nil data.to_a
      assert_instance_of Tableau, data.to_a.first
      assert_instance_of Pile,    data.to_a[1]
      assert_instance_of Card,    data.to_a.last
    end

    def test_data_collector_can_represent_data_as_string
      data = @data_miss.dup
      empty_message = "Click on card , in pile , in the region of "
      assert_equal empty_message, data.to_s
      data.gather!
      assert_equal empty_message, data.to_s

      data = @data_exist.dup
      assert_equal empty_message, data.to_s
      data.gather!
      card = "Click on card Two of Hearts"
      pile = /in pile #<Patience::Pile:.+>/
      area = /in the region of #<Patience::Tableau:.+>/
      message = /^#{card}, #{pile}, #{area}$/
      assert_match message, data.to_s
    end

    def test_data_collector_can_find_data_in_area_and_pile_and_card
      data = @data_miss.dup
      [:area, :pile, :card].each { |method| assert_nil data.send(method) }
      data.send(:find_all)
      [:area, :pile, :card].each { |method| assert_nil data.send(method) }

      data = @data_exist.dup
      [:area, :pile, :card].each { |method| assert_nil data.send(method) }
      data.send(:find_all)
      [:area, :pile, :card].each { |method| refute_nil data.send(method) }
    end

    def test_data_collector_can_find_data_only_in_pile
      data = @data_miss.dup
      [:area, :pile, :card].each { |method| assert_nil data.send(method) }
      data.send(:find_pile)
      [:area, :pile, :card].each { |method| assert_nil data.send(method) }

      mouse_pos = Ray::Vector2[142, 24]
      data = EventHandler::Click::DataCollector.new(mouse_pos, @areas)
      data.send(:find_pile)
      [:area, :pile].each { |method| refute_nil data.send(method) }
      assert_nil data.card
    end

  end
end
