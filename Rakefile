require 'rake/testtask'
require 'releasy'

desc 'Release easy'
Releasy::Project.new do
  name       'Patience'
  version    '0.0.0'

  executable    'bin/patience'
  files         'lib/**/*'
  exposed_files '[A-Z]*'

  add_link 'https://github.com/kyrylo/patience', 'The repository of Patience'
  exclude_encoding

  add_build :source do
    add_package :"7z"
  end

  add_build :windows_installer do
    icon 'icon.ico'
    start_menu_group 'Patience'
    readme 'README'
    license 'LICENSE'
    executable_type :windows
    add_package :zip
  end

end

desc 'Run tests'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/test_*.rb'
  t.verbose = true
end

task :default => :test
