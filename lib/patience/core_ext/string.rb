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
