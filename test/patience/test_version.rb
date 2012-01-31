require_relative 'helper'

module Patience
  class TestVERSION < MiniTest::Unit::TestCase

    def test_version_is_correct
      assert_equal "0.0.0", Patience::VERSION, "Patience version isn't correct"
    end

  end
end
