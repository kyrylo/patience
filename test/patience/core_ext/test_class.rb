require_relative '../helper'

module Patience
  class TestClass < TestCase

    class Parent
    end

    class Child1 < Parent
    end

    class Child2 < Parent
    end

    class Grandchild1 < Child1
    end

    class Grandchild2 < Child1
    end

    test 'Descendats' do
      assert_equal [Grandchild2, Grandchild1, Child2, Child1], Parent.descendants
      assert_equal [Grandchild2, Grandchild1], Child1.descendants
      assert_equal [], Child2.descendants
    end

  end
end
