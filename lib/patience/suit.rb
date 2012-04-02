module Patience
  class Card
    ###
    # Suit supplies only one method: #red?. The idea is that every
    # actual suit has its own class, which is inherited from Suit.
    # Each suit class defines its own #black? method dynamically.
    class Suit
      ##
      # This lambda defines new class, designed to be a child
      # of Suit and supplied with #black? method, contents of
      # which depends on the given argument "true_or_false".
      create_suit_class = lambda { |num, true_or_false|
        Class.new(Suit) do
          include Comparable

          define_method :initialize do
            @num = num
          end

          # Returns boolean value. For red suits the value
          # is "false". For black suits the value is "true".
          define_method :black? do
            true_or_false
          end

          # Returns integer representation of a suit.
          # Example:
          def to_i
            @num
          end
        end
      }

      # Create classes for every suit, giving the answer on the question about
      # their blackness. If the answer is negative, obviously the suit is red.
      Heart   = create_suit_class.call(1, false)
      Diamond = create_suit_class.call(2, false)
      Spade   = create_suit_class.call(3, true)
      Club    = create_suit_class.call(4, true)

      # Checks whether card is "red" (being not black).
      # The opposite of the Card#black?. Returns true
      # if the card is red. Otherwise, returns false.
      def red?
        not black?
      end

      # Returns plural string representation of a suit. It asks class to
      # give its full name, exscinding everything but its actual name.
      def to_s
        "#{self.class.name.demodulize}s"
      end

      # Compares two suits with each other for equality.
      def <=>(other_suit)
        @num <=> other_suit.to_i
      end

      # Returns true, if the color of suit is
      # the same as the color of other suit.
      def same_color?(other_suit)
        (black? && other_suit.black?) || (red? && other_suit.red?)
      end

      # Returns true if the color of suit
      # of differs from other suit's color.
      def different_color?(other_suit)
        (black? && other_suit.red?) || (red? && other_suit.black?)
      end

    end
  end
end
