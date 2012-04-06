require 'ray'
require 'forwardable'
require 'psych'

def path_of(resource)
  File.join(File.expand_path('../', File.dirname(__FILE__)), resource)
end

def image_path(image, ext='png')
  path_of File.join('gfx', "#{image}.#{ext}")
end

def layout_path(template)
  path_of File.join('lib/patience/layout', "#{template}.yml")
end

Dir.chdir(File.dirname(__FILE__)) do
  Dir['patience/event_handlers/*.rb'].each { |eh| require_relative eh }
  Dir['patience/core_ext/*.rb'].each { |ext| require_relative ext }
  Dir['patience/scenes/*.rb'].each { |scene| require_relative scene }
  Dir['patience/*.rb'].each { |file| require_relative file }
end

module Patience
  # Public: Layout for Foundation area.
  FOUNDATION = Psych.load_file layout_path('foundation')

  # Public: Layout for Tableau area.
  TABLEAU    = Psych.load_file layout_path('tableau')

  # Public: Layout for Waste area.
  WASTE      = Psych.load_file layout_path('waste')

  # Public: Layout for Stock area.
  STOCK      = Psych.load_file layout_path('stock')
end
