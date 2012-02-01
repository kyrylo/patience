require_relative '../../helper'

module Patience
  class TestClick < MiniTest::Unit::TestCase

    def setup
      @mouse_pos_missclick = Ray::Vector2[0, 0]
      @mouse_pos_hit = Ray::Vector2[32, 166]
      @deck = Deck.new
      @areas = { :tableau => Tableau.new(@deck.shuffle_off! 28),
                 :waste => Waste.new }
      @click_miss = EventHandler::Click.new(@mouse_pos_missclick, @areas)
      @click_hit  = EventHandler::Click.new(@mouse_pos_hit, @areas)
    end

    def test_click_can_be_created
      assert EventHandler::Click.new(@mouse_pos_hit, @areas)
    end

    def test_click_is_an_instance_of_click_class
      assert_instance_of EventHandler::Click, @click_hit
    end

    def test_click_accepts_two_arguments
      assert_raises(ArgumentError) { EventHandler::Click.new }
      assert_raises(ArgumentError) { EventHandler::Click.new(@mouse_pos_hit) }
      assert_raises(ArgumentError) do
        EventHandler::Click.new(@mouse_pos_hit, @areas, 10)
      end
    end

    def test_click_responds_to_instance_methods
      methods = [:offset, :exec]
      methods.each { |method| assert_respond_to @click_hit, method }
    end

    def test_click_responds_to_protected_methods
      protected_methods = [:stock, :waste, :tableau, :foundation]
      protected_methods.each { |method| assert_respond_to @click_hit, method }
    end

    def test_click_responds_to_delegated_methods
      delegated_methods = [:pick_up, :card, :pile, :nothing?, :something?]
      delegated_methods.each { |method| assert_respond_to @click_hit, method }
    end

    # Test exec stuff
    # ...

  end
end
