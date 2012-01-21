require_relative '../helper'

module Patience
  class TestObject < MiniTest::Unit::TestCase

    def test_the_not_object_does_negate_true_to_false
      refute nil.not.nil?, "The Not object doesn't negate true to false"
    end

    def test_the_not_object_does_negate_false_to_true
      assert Object.new.not.nil?, "The Not object doesn't negate false to true"
    end

  end
end
