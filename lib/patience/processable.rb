module Patience
  ###
  # Processable module.
  module Processable
    attr_reader :area, :pile, :card

    # Finds the area or pile, or card (depends on the option)
    # in the areas. If option is wrong, raises ArgumentError.
    def select_in(areas, option, &blk)
      case option
        when :area then find_area_in(areas, &blk)
        when :pile then find_pile_in(areas, &blk)
        when :card then find_card_in(areas, &blk)
      else
        raise ArgumentError, "Unknown option: #{option}"
      end
    end

    # Returns the area, which is being clicked.
    def find_area_in(areas)
      areas.values.find { |area| yield(area) }
    end

    # Returns the pile, which is being clicked.
    def find_pile_in(areas)
      find_area_in(areas) do |area|
        pile = area.piles.find { |pile| yield(pile) }
        return pile unless pile.nil?
      end
      nil
    end

    # Returns the card, which is being clicked.
    def find_card_in(areas)
      find_pile_in(areas) do |pile|
        card = pile.cards.reverse.find { |card| yield(card) }
        return card unless card.nil?
      end
      nil
    end

    # Returns the array, containing gathered hit elements.
    def to_a
      [area, pile, card]
    end

    # Returns the hash, containing gathered hit elements.
    def to_h
      { :area => area, :pile => pile, :card => card }
    end

    # Returns true, if there hasn't been found
    # something. Otherwise, returns false.
    def nothing?
      to_a.compact.size.zero?
    end

    # Returns true, if there's been found something.
    # Otherwise, returns false. Opposite of #nothing?.
    def something?
      not nothing?
    end

    # Returns subtraction between card and mouse position at the moment
    # of click, only if cursor clicked the card. Otherwise, returns nil.
    def pick_up(card, mouse_pos)
      card.pos - mouse_pos if card
    end

    # Returns true, if the clicked area is Stock. Otherwise, returns false.
    def stock?
      area.instance_of? Stock
    end

    # Returns true, if the clicked area is Waste. Otherwise, returns false.
    def waste?
      area.instance_of? Waste
    end

    # Returns true, if the clicked area is Tableau. Otherwise, returns false.
    def tableau?
      area.instance_of? Tableau
    end

    # Returns true, if the clicked area is Foundation. Otherwise, returns false.
    def foundation?
      area.instance_of? Foundation
    end

    # Deletes card from the pile and returns it. It is used in scenarios.
    def exempt(card)
      pile.cards.delete(card)
    end

  end
end
