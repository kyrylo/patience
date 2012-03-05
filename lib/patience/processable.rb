module Patience
  module Processable
    attr_reader :area, :pile, :card

    # Finds area or pile, or card (depends on the option) in
    # the areas. If the option is wrong, raises ArgumentError.
    def detect_in(areas, option, &block)
      case option
        when :area then find_area_in(areas, &block)
        when :pile then find_pile_in(areas, &block)
        when :card then find_card_in(areas, &block)
      else
        raise ArgumentError, "Unknown option: #{option}"
      end
    end

    # Returns area, which is being clicked.
    def find_area_in(areas)
      areas.values.find { |area| yield(area) }
    end

    # Returns pile, which is being clicked.
    def find_pile_in(areas)
      find_area_in(areas) do |area|
        pile = area.piles.find { |pile| yield(pile) }
        return pile unless pile.nil?
      end
      nil
    end

    # Returns card, which is being clicked.
    def find_card_in(areas)
      find_pile_in(areas) do |pile|
        card = pile.cards.reverse.find { |card| yield(card) }
        return card unless card.nil?
      end
      nil
    end

    # Returns array, containing gathered hit elements.
    def to_a
      [area, pile, card]
    end

    # Returns hash, containing gathered hit elements.
    def to_h
      { :area => area, :pile => pile, :card => card }
    end

    # Returns true, if there hasn't been found something.
    def nothing?
      to_a.compact.size.zero?
    end

    # Returns true, if there's been found something. Opposite of #nothing?.
    def something?
      not nothing?
    end

    # Returns subtraction between card and mouse position at
    # the moment of click, only if cursor clicked the card.
    def pick_up(card, mouse_pos)
      card.pos - mouse_pos
    end

    # Returns true, if the clicked area is Stock.
    def stock?
      area.instance_of? Stock
    end

    # Returns true, if the clicked area is Waste.
    def waste?
      area.instance_of? Waste
    end

    # Returns true, if the clicked area is Tableau.
    def tableau?
      area.instance_of? Tableau
    end

    # Returns true, if the clicked area is Foundation.
    def foundation?
      area.instance_of? Foundation
    end

  end
end
