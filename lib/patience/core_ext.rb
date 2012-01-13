require 'rake'

class String

  rake_extension("demodulize") do

    # Removes the module part from the
    # constant expression in the string.
    def demodulize
      self.to_s.gsub(/^.*::/, '')
    end

  end

end
