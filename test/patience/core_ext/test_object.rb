require_relative '../helper'

module Patience
  class TestObject < TestCase

    test 'The not object does negate true to false' do
      refute nil.not.nil?, "The Not object doesn't negate true to false"
    end

    test 'The not object does negate false to true' do
      assert Object.new.not.nil?, "The Not object doesn't negate false to true"
    end

  end
end
