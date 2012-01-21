require 'rake'

class Object
  rake_extension("not") do
    def not
      Not.new(self)
    end
  end

  ###
  # The original idea blongs to Jay Fields:
  # http://blog.jayfields.com/2007/08/ruby-adding-not-method-for-readability.html
  #
  # The Object::Not instances are proxies, that send all calls back to the
  # original instance. The Object::Not class privatizes almost all of its
  # methods so that most method calls will be handled by method_missing.
  class Not
    private *instance_methods.select { |m| m !~ /(^__|^\W|^binding$)/ }

    rake_extension("initialize") do
      def initialize(subject)
        @subject = subject
      end
    end

    rake_extension("method_missing") do

      # Forwards on any method call to the subject and negates the result.
      def method_missing(sym, *args, &block)
        !@subject.send(sym, *args, &block)
      end

    end

  end

end
