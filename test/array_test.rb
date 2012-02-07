$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'buckets/ext/array'

class ArrayTest < Test::Unit::TestCase
  def test_to_positive_int_array
    assert_equal([], "".split(" ").to_positive_int_array)
    assert_equal([1,2,3], "1 2 3".split(" ").to_positive_int_array)
    assert_raise(ArgumentError) { "1 2 a".split(" ").to_positive_int_array }
  end
end
