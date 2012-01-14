require 'rake'

class String
  rake_extension("demodulize") do

    # Removes the module part from the
    # constant expression in the string.
    def demodulize
      self.to_s.gsub(/^.*::/, '')
    end

  end

  rake_extension("constantize") do

    # Constantize tries to find a declared constant with the name specified
    # in the string. It raises a NameError when the name is not in CamelCase
    # or is not initialized.
    # Example:
    #   "Module".constantize #=> Module
    #   "Class".constantize  #=> Class
    #   "yadda".constantize  #=> NameError: yadda is not a valid constant name!
    #
    def constantize
      unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ self
        raise NameError, "#{self.inspect} is not a valid constant name!"
      end

      Object.module_eval("::#{$1}", __FILE__, __LINE__)
    end

  end
end

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
