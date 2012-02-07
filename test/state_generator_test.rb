$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'buckets/state_generator'
require 'buckets/instance'

class StateGeneratorTest < Test::Unit::TestCase
  def setup
    @sg = Buckets::StateGenerator.new(Buckets::Instance.new(1, 3, [4,5,7], [2,1,0], [2,4,3]))
    eval "def @sg.original_state; @original_state; end"
    eval "def @sg.first_index; @first_index; end"
    eval "def @sg.second_index; @second_index; end"
    eval "def @sg.operation; @operation; end"
  end

  def test_init
    assert_equal([2,1,0], @sg.original_state)
    inner_state_assertion(0, 1, :fill)
  end

  def test_next_state
    assert_equal(true, @sg.has_next_state?)

    # fill bucket
    assert_equal([4,1,0], @sg.get_next_state)
    assert_equal([2,5,0], @sg.get_next_state)
    assert_equal([2,1,7], @sg.get_next_state)

    # empty bucket
    assert_equal([0,1,0], @sg.get_next_state)
    assert_equal([2,0,0], @sg.get_next_state)
    assert_nil(@sg.get_next_state)

    # pour buckets
    assert_equal([0,3,0], @sg.get_next_state)
    assert_equal([0,1,2], @sg.get_next_state)
    assert_equal([3,0,0], @sg.get_next_state)
    assert_equal([2,0,1], @sg.get_next_state)
    assert_nil(@sg.get_next_state)
    assert_nil(@sg.get_next_state)
  end

  def test_bucket_operations
    Buckets::StateGenerator.send(:public, :fill_bucket)
    assert_equal([4,0,0], @sg.fill_bucket([0,0,0],0))
    
    Buckets::StateGenerator.send(:public, :empty_bucket)
    assert_equal([0,1,1], @sg.empty_bucket([1,1,1],0))
    
    Buckets::StateGenerator.send(:public, :pour_buckets)
    assert_equal([0,2,0], @sg.pour_buckets([1,1,0],0,1))
    assert_equal([2,0,0], @sg.pour_buckets([1,1,0],1,0))
    assert_equal([1,5,0], @sg.pour_buckets([1,5,0],0,1))
    assert_equal([4,2,0], @sg.pour_buckets([1,5,0],1,0))
  end

  def test_count_next_index
    Buckets::StateGenerator.send(:public, :count_next_index)

    # indexes for fill operation
    inner_state_assertion(0, 1, :fill)
    @sg.count_next_index()
    inner_state_assertion(1, 1, :fill)
    @sg.count_next_index()
    inner_state_assertion(2, 1, :fill)

    # indexes for empty operation
    @sg.count_next_index()
    inner_state_assertion(0, 1, :empty)
    @sg.count_next_index()
    inner_state_assertion(1, 1, :empty)
    @sg.count_next_index()
    inner_state_assertion(2, 1, :empty)

    # indexes for pour operation
    @sg.count_next_index()
    inner_state_assertion(0, 1, :pour)
    @sg.count_next_index()
    inner_state_assertion(0, 2, :pour)
    @sg.count_next_index()
    inner_state_assertion(1, 0, :pour)
    @sg.count_next_index()
    inner_state_assertion(1, 2, :pour)
    @sg.count_next_index()
    inner_state_assertion(2, 0, :pour)
    @sg.count_next_index()
    inner_state_assertion(2, 1, :pour)

    # no operation
    @sg.count_next_index()
    inner_state_assertion(2, 3, :nop)
    assert_equal(false, @sg.has_next_state?)  
  end

  def inner_state_assertion(i1, i2, op)
    assert_equal(i1, @sg.first_index)
    assert_equal(i2, @sg.second_index)
    assert_equal(op, @sg.operation)
  end
end
