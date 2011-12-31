require_relative 'helper'

module Patience
  class TestVersion < MiniTest::Unit::TestCase

    def test_version_has_major_number
      assert Version::MAJOR
    end

    def test_major_number_is_fixnum
      assert_instance_of Fixnum, Version::MAJOR
    end

    def test_version_has_minor_number
      assert Version::MINOR
    end

    def test_minor_number_is_fixnum
      assert_instance_of Fixnum, Version::MINOR
    end

    def test_version_has_tiny_number
      assert Version::TINY
    end

    def test_tiny_number_is_fixnum
      assert_instance_of Fixnum, Version::TINY
    end

    def test_version_numbers_can_be_concatenated_together
      assert_instance_of String, Version::STRING
    end

  end
end
