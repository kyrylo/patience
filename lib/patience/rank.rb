module Patience
  class Card
    ###
    # Rank class provides underlying methods for every rank.
    class Rank
      ##
      # This lambda defines the new class, designed to be a child of Rank.
      create_rank_class = lambda { |num|
        Class.new(Rank) do
          include Comparable

          define_method :initialize do
            @num = num
          end

          # Returns integer representation of the rank. Basically, it's
          # the position of the card in the ascending row of card ranks.
          def to_i
            @num
          end

          # Returns string representation of a rank. It asks class to
          # give its full name, exscinding everything but its actual name.
          def to_s
            "#{self.class.name.demodulize}"
          end

          # Compares two ranks with each other. Based on integer values.
          def <=>(other_rank)
            self.to_i <=> other_rank.to_i
          end
        end
      }

      # Dynamically create rank classes.
      %w[Two Three Four Five Six Seven
         Eight Nine Ten Jack Queen King Ace].each_with_index do |class_name, i|
        Rank.const_set(class_name, create_rank_class.call(i+1))
      end
    end
  end
end
