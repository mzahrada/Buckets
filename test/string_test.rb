$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'buckets/ext/string'

class StringTest < Test::Unit::TestCase
  def test_is_positive_int
    assert_equal(false, '1.23'.is_positive_int?)
    assert_equal(false, 'a'.is_positive_int?)
    assert_equal(false, '12.2.1'.is_positive_int?)
    assert_equal(false, '12-2'.is_positive_int?)
    assert_equal(false, '-1'.is_positive_int?)
    assert_equal(true, '12'.is_positive_int?)
    assert_equal(true, '0'.is_positive_int?)
  end
end
