$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'buckets/instance'

class InstanceTest < Test::Unit::TestCase
  def test_init
    i = Buckets::Instance.new(1, 2, [4,5], [0,1], [2,4])
    assert_equal(1, i.id)
    assert_equal(2, i.count)
    assert_equal([4,5], i.capacities)
    assert_equal([0,1], i.init_capacities)
    assert_equal([2,4], i.final_capacities)
  end
  def test_init_error
    assert_raise(ArgumentError) { Buckets::Instance.new(1, 2, [4,5,6], [0,1], [2,4]) }
    assert_raise(ArgumentError) { Buckets::Instance.new(1, 2, [4,5], [0,1,0], [2,4]) }
    assert_raise(ArgumentError) { Buckets::Instance.new(1, 2, [4,5], [0,1], [2]) }
  end
  def test_capacities_error
    assert_raise(ArgumentError) { Buckets::Instance.new(1, 2, [4,5], [0,9], [2,4]) }
    assert_raise(ArgumentError) { Buckets::Instance.new(1, 2, [4,5], [0,2], [9,4]) }
  end
end
