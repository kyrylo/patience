require_relative '../helper'

module Please
  module Forgive
    class Me
    end
  end
end

module Patience
  class TestString < MiniTest::Unit::TestCase

    def test_demodulize
      assert_equal "Changes", "Going::Through::Changes".demodulize
    end

    def test_constantize
      assert_equal Please::Forgive::Me, "Please::Forgive::Me".constantize
      assert_equal Please::Forgive::Me, "::Please::Forgive::Me".constantize
      assert_equal Please::Forgive, "Please::Forgive".constantize
      assert_equal Please::Forgive, "::Please::Forgive".constantize
      assert_equal Please, "Please".constantize
      assert_equal Please, "::Please".constantize
      assert_raises(NameError) { "UnknownClass".constantize }
      assert_raises(NameError) { "UnknownClass::NotForToffy".constantize }
      assert_raises(NameError) { "UnknownClass::Please".constantize }
      assert_raises(NameError) { "UnknownClass::Please::Forgive".constantize }
      assert_raises(NameError) { "An invalid string".constantize }
      assert_raises(NameError) { "InvalidClass\n".constantize }
      assert_raises(NameError) { "Please::TestString".constantize }
      assert_raises(NameError) { "Please::Forgive::TestString".constantize }
    end

  end
end
