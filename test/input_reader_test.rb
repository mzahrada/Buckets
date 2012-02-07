$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'buckets/input_reader'

class InputReaderTest < Test::Unit::TestCase
  def test_get_instances_ok
    instances = Buckets::InputReader.get_instances("test.inst.ok.dat")
    assert_equal(3, instances.size)
    assert_equal(11, instances[0].id)
    assert_equal([12,6,6,2,4], instances[2].final_capacities)
  end

  def test_get_instances_error
    assert_raise(ArgumentError) { Buckets::InputReader.get_instances("test.inst.error.dat") }
    assert_raise(ArgumentError) { Buckets::InputReader.get_instances("test.inst.error2.dat") }
  end
end
