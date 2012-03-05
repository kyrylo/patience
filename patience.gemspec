Gem::Specification.new do |s|
  s.name         = 'patience'
  s.version      = '0.0.0'
  s.author       = 'Kyrylo Silin'
  s.email        = 'kyrylosilin@gmail.com'
  s.homepage     = 'https://github.com/kyrylo/patience'
  s.license      = 'MIT'
  s.summary      = 'Klondike solitaire game.'
  s.description  = 'Klondike solitaire game which is built with help of Ray game library.'
  s.post_install_message = "To run the game, type 'patience' in your terminal."

  s.files        = Dir['{bin,lib}/**/*', '[A-Z]*']
  s.bindir       = 'bin'
  s.require_path = 'lib'
  s.test_files   = Dir['test/**/*']
  s.executable   = 'patience'

  s.add_runtime_dependency 'ray', '~> 0.2.0'
  s.required_ruby_version = '>= 1.9.3'
end
