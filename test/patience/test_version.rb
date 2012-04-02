require_relative 'helper'

module Patience
  class TestVERSION < TestCase

    test 'The Patience version is correct' do
      assert_equal "0.1.1", Patience::VERSION
    end

  end
end
