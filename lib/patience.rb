require 'ray'
require 'forwardable'

def path_of(resource)
  File.join(File.dirname(__FILE__), resource)
end

Dir.chdir(File.dirname(__FILE__)) do
  Dir['patience/scenes/*.rb'].each { |scene| require_relative scene }
  Dir['patience/*.rb'].each { |file| require_relative file }
end
