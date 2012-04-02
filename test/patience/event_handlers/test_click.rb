require_relative '../helper'

module Patience
  class TestClick < TestCase

    class Dummy < EventHandler::Click
      attr_accessor :area, :pile, :card, :cards, :scenario

      def initialize(mouse_pos, areas)
        @mouse_pos = mouse_pos
        @areas = areas
      end
    end

    def setup
      @mouse_pos_missclick = Ray::Vector2[0, 0]
      @mouse_pos_hit = Ray::Vector2[32, 175]
      @deck = Deck.new
      @areas = { :tableau => Tableau.new(@deck.shuffle_off! 28),
                 :waste => Waste.new,
                 :stock => Stock.new(@deck.shuffle_off! 10) }
      @dummy_click_miss = Dummy.new(@mouse_pos_missclick, @areas)
      @dummy_click_hit  = Dummy.new(@mouse_pos_hit, @areas)
      @stock_hit = Dummy.new(Ray::Vector2[32, 28], @areas)
    end

    def fill_attributes_up(click)
      click.area  = click.send(:detect_area)
      click.pile  = click.send(:detect_pile)
      cards = click.send(:collect_cards)
      click.cards = cards.map(&:first) if cards
      click.card  = click.cards.first
    end

    test 'An area can be selected by click' do
      assert_nil @dummy_click_hit.area
      @dummy_click_hit.area = @dummy_click_hit.send(:detect_area)
      assert_instance_of Tableau, @dummy_click_hit.area
      assert_kind_of     Area,    @dummy_click_hit.area

      assert_nil @dummy_click_miss.area
      @dummy_click_miss.area = @dummy_click_miss.send(:detect_area)
      assert_nil @dummy_click_miss.area
    end

    test 'A pile can be selected by click' do
      assert_nil @dummy_click_hit.pile
      @dummy_click_hit.pile = @dummy_click_hit.send(:detect_pile)
      assert_instance_of Pile, @dummy_click_hit.pile

      assert_nil @dummy_click_miss.pile
      @dummy_click_miss.pile = @dummy_click_miss.send(:detect_pile)
      assert_nil @dummy_click_miss.pile
    end

    test 'A card can be selected by click' do
      # Hit
      tableau_click = Dummy.new(Ray::Vector2[472, 176], @areas)
      assert_nil tableau_click.card
      assert_nil tableau_click.cards
      tableau_click.pile = @areas[:tableau].piles[4]

      [Card.new(3, 1), Card.new(2, 4)].each do |card|
        @areas[:tableau].piles[4] << card
        card.pos = @areas[:tableau].piles[4].cards[-2].pos + [0, 19]
      end

      tableau_click.cards = tableau_click.send(:collect_cards).map(&:first)
      assert tableau_click.cards
      assert_instance_of Card::Rank::Three, tableau_click.cards[0].rank
      assert_instance_of Card::Rank::Three, tableau_click.cards[1].rank
      assert_instance_of Card::Rank::Four,  tableau_click.cards[2].rank

      # Miss
      assert_nil @dummy_click_miss.card
      assert_nil @dummy_click_miss.cards
      @dummy_click_miss.cards = @dummy_click_miss.send(:collect_cards)
      assert_nil @dummy_click_miss.card
      assert_nil @dummy_click_miss.cards
    end

    test 'Stock can be refilled by a click' do
      assert_equal 10, @areas[:stock].cards.size
      assert_equal 0,  @areas[:waste].cards.size

      @areas[:stock].cards.each do |card|
        @areas[:waste].piles[0] << card
      end
      @areas[:stock].piles[0].cards.clear

      assert_equal 0,  @areas[:stock].cards.size
      assert_equal 10, @areas[:waste].cards.size

      @dummy_click_hit.send(:refill_stock)
      assert_equal 10, @areas[:stock].cards.size
      assert_equal 0,  @areas[:waste].cards.size
    end

    test 'A card can be displaced from Stock to Waste by a click' do
      assert_equal 10, @areas[:stock].cards.size
      assert_equal 0,  @areas[:waste].cards.size

      fill_attributes_up(@stock_hit)
      @stock_hit.send(:displace_to_waste)
      assert_equal 9, @areas[:stock].cards.size
      assert_equal 1, @areas[:waste].cards.size

      fill_attributes_up(@stock_hit)
      @stock_hit.send(:displace_to_waste)
      assert_equal 8, @areas[:stock].cards.size
      assert_equal 2, @areas[:waste].cards.size
    end

    test 'Stock can change its background as a function of conditions' do
      stock = @areas[:stock].piles[0]
      @stock_hit.scenario = -> { @stock_hit.send(:stock) }
      normal_background = @areas[:stock].piles[0].background.object_id
      assert normal_background, stock.background.object_id
      assert_equal 10, stock.size

      fill_attributes_up(@stock_hit)
      @stock_hit.scenario.call
      assert normal_background, stock.background.object_id
      assert_equal 9, stock.size

      stock.size.times do
        fill_attributes_up(@stock_hit)
        @stock_hit.scenario.call
      end

      empty_background = stock.background.object_id
      refute_equal normal_background, empty_background
      assert_equal 0, stock.size

      fill_attributes_up(@stock_hit)
      @stock_hit.scenario.call
      refute_equal empty_background, stock.background.object_id
      refute_equal empty_background, normal_background
    end

  end
end
