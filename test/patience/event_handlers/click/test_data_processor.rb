require_relative '../../helper'

module Patience
  class TestClickDataProcessor < MiniTest::Unit::TestCase

    def setup
      @mouse_pos_missclick = Ray::Vector2[0, 0]
      @mouse_pos_hit = Ray::Vector2[32, 166]
      @deck = Deck.new
      @areas = { :tableau    => Tableau.new(@deck.shuffle_off! 28),
                 :stock      => Stock.new(@deck.shuffle_off! 24),
                 :waste      => Waste.new,
                 :foundation => Foundation.new }
      @processor_miss = EventHandler::Click::DataProcessor.new(
                                                   @mouse_pos_missclick, @areas)
      @processor_hit = EventHandler::Click::DataProcessor.new(@mouse_pos_hit,
                                                              @areas)
    end

    def test_data_processor_can_be_created
      assert EventHandler::Click::DataProcessor.new(
                                                   @mouse_pos_missclick, @areas)
    end

    def test_data_processor_is_an_instance_of_data_processor_class
      assert_instance_of EventHandler::Click::DataProcessor, @processor_miss
    end

    def test_data_processor_accepts_two_arguments
      assert_raises(ArgumentError) do
        EventHandler::Click::DataProcessor.new
      end

      assert_raises(ArgumentError) do
        EventHandler::Click::DataProcessor.new(@mouse_pos_missclick)
      end

      assert_raises(ArgumentError) do
        EventHandler::Click::DataProcessor.new(@mouse_pos_missclick, @area, 10)
      end
    end

    def test_data_processor_responds_to_instance_methods
      methods = [:data, :nothing?, :something?, :pile, :card, :pick_up,
                 :stock?, :waste?, :tableau?, :foundation?, :stock_scenario,
                 :waste_scenario, :tableau_scenario, :foundation_scenario]
      methods.each { |method| assert_respond_to @processor_miss, method }
    end

    def test_data_processor_responds_to_protected_methods
      protected_methods = [:exempt]
      protected_methods.each { |meth| assert_respond_to @processor_miss, meth }
    end

    def test_data_processor_can_check_if_cursor_clicked_nothing
      assert @processor_miss.nothing?
      refute @processor_miss.something?
    end

    def test_data_processor_can_check_if_cursor_clicked_something
      assert @processor_hit.something?
      refute @processor_hit.nothing?
    end

    def test_data_processor_can_return_clicked_pile
      assert_nil @processor_miss.pile
      assert_instance_of Pile, @processor_hit.pile
    end

    def test_data_processor_can_return_clicked_card
      assert_nil @processor_miss.card
      assert_instance_of Card, @processor_hit.card
    end

    def test_data_processor_can_pick_up_a_card
      assert_nil @processor_miss.pick_up
      assert_equal Ray::Vector2[-1, -1], @processor_hit.pick_up
    end

    def test_data_processor_can_check_if_stock_was_clicked
      m_pos = Ray::Vector2[40, 40]
      processor_hit = EventHandler::Click::DataProcessor.new(m_pos, @areas)
      assert processor_hit.stock?
    end

    def test_data_processor_can_check_if_waste_was_clicked
      m_pos = Ray::Vector2[160, 40]
      processor_hit = EventHandler::Click::DataProcessor.new(m_pos, @areas)
      assert processor_hit.waste?
    end

    def test_data_processor_can_check_if_tableau_was_clicked
      m_pos = Ray::Vector2[32, 166]
      processor_hit = EventHandler::Click::DataProcessor.new(m_pos, @areas)
      assert processor_hit.tableau?
    end

    def test_data_processor_can_check_if_foundation_was_clicked
      m_pos = Ray::Vector2[590, 40]
      processor_hit = EventHandler::Click::DataProcessor.new(m_pos, @areas)
      assert processor_hit.foundation?
    end

    # TODO: Improve scenario asserts: currently, there
    # is no way to test the code inside of the Procs.
    def test_data_processor_can_create_scenario_for_clicking_on_stock_event
      assert_instance_of Proc, @processor_hit.stock_scenario
    end

    def test_data_processor_can_create_scenario_for_clicking_on_waste_event
      assert_instance_of Proc, @processor_hit.waste_scenario
    end

    def test_data_processor_can_create_scenario_for_clicking_on_tableau_event
      assert_instance_of Proc, @processor_hit.tableau_scenario
    end

    def test_data_processor_can_create_scenario_for_clicking_on_foundation_event
      assert_instance_of Proc, @processor_hit.foundation_scenario
    end

    def test_data_processor_can_exempt_card_from_the_clicked_pile
      assert_raises(NoMethodError) do
        @processor_miss.send(:exempt, Card.new(1, 1))
      end

      assert_equal 1, @processor_hit.pile.size
      assert_equal "Two of Hearts",
                   @processor_hit.send(:exempt, @processor_hit.card).to_s
      assert_equal 0, @processor_hit.pile.size
    end

  end
end
