require 'minitest/autorun'
require_relative '../../lib/patience'

class TestCase < MiniTest::Unit::TestCase
  def self.test(name, &blk)
    define_method('test_' + name, &blk) if blk
  end
end
