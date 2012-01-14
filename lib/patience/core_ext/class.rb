require 'rake'

class Class
  rake_extension("descendants") do

    # Returns the array of all descendants of a class. Although there is
    # faster way to do this, I want to stick with this solutions, since
    # it's much simpler to understand and performance isn't crucial for now.
    #
    # The example of faster implementation lives in:
    # rails/activesupport/lib/active_support/descendants_tracker.rb
    def descendants
      ObjectSpace.each_object(::Class).select {|klass| klass < self }
    end

  end
end
