require 'ray'
require 'forwardable'

def path_of(resource)
  File.join(File.expand_path('../', File.dirname(__FILE__)), resource)
end

def image_path(image, ext='png')
  path_of File.join('gfx', "#{image}.#{ext}")
end

Dir.chdir(File.dirname(__FILE__)) do
  Dir['patience/event_handlers/*.rb'].each { |eh| require_relative eh }
  Dir['patience/core_ext/*.rb'].each { |ext| require_relative ext }
  Dir['patience/scenes/*.rb'].each { |scene| require_relative scene }
  Dir['patience/*.rb'].each { |file| require_relative file }
end
