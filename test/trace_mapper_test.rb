$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'buckets/trace_mapper'

class TraceMapperTest < Test::Unit::TestCase
  def setup
    @state = [0,1,0]
    @state2 = [1,1,0]
    state3a = [2,1,0]
    @state3b = [1,2,0]
    @not_stored_state = [1,1,1]

    @tm = Buckets::TraceMapper.new(@state)
    @tm.store_state(@state2, @state)
    @tm.store_state(state3a, @state2)
    @tm.store_state(@state3b, @state2)
  end

  def test_get_predecessor
    pred = @tm.get_predecessor(@state)
    assert_equal("first", pred)

    pred = @tm.get_predecessor(@not_stored_state)
    assert_equal(nil, pred)

    pred = @tm.get_predecessor(@state2)
    assert_equal(@state, pred)
  end

  def test_contains_state
    assert_equal(false, @tm.contains_state?(@not_stored_state))
    assert_equal(true, @tm.contains_state?(@state2))
  end

  def test_trace
    assert_nil(@tm.trace)
    assert_nil(@tm.trace_length)

    @tm.count_trace(@state3b)

    assert_equal(2, @tm.trace_length)
    assert_equal("first >> 0,1,0 >> 1,1,0 >> 1,2,0", @tm.trace)
  end
end
