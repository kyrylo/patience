require 'ray'
require 'forwardable'

Dir.chdir(File.dirname(__FILE__)) do
  Dir['patience/scenes/*.rb'].each { |scene| require_relative scene }
  Dir['patience/*.rb'].each { |file| require_relative file }
end
