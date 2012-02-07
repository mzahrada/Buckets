$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'buckets/buckets_solver'
require 'buckets/instance'
require 'buckets/csv_results_writer'

class BucketsSolverTest < Test::Unit::TestCase

  B_EMPTY = [0,0,0]
  B_FULL = [4,5,7]
  B_INIT = [0,1,0]
  B_FINAL = [2,4,5]
  B_TEST_1 = [1,1,1]
  B_TEST_2 = [1,2,4]
  B_TEST_3 = [1,2,5]

  def setup
    @solver = Buckets::BucketSolver.new(Buckets::Instance.new(1, 3, B_FULL, B_INIT, B_FINAL), :sco)
    eval "def @solver.get_queue; @queue; end"
    eval "def @solver.get_get_state; @get_state; end"
    eval "def @solver.get_add_state; @add_state; end"
    eval "def @solver.get_instance; @instance; end"
    eval "def @solver.get_method; @method; end"
    eval "def @solver.get_trace_mapper; @trace_mapper; end"
    eval "def @solver.get_state_generator; @state_generator; end"
  end
  
  def test_init
    assert_not_nil(@solver.get_instance)
    assert_not_nil(@solver.get_method)
    assert_not_nil(@solver.get_trace_mapper)
    assert_not_nil(@solver.get_state_generator)
    assert_not_nil(@solver.get_queue)
    assert_not_nil(@solver.get_get_state)
    assert_not_nil(@solver.get_add_state)
  end


  
  def test_manhattan_priority
    Buckets::BucketSolver.send(:public, :manhattan_priority)
    assert_equal(11,@solver.manhattan_priority(B_EMPTY))
    assert_equal(5, @solver.manhattan_priority(B_FULL))

    assert_equal(8, @solver.manhattan_priority(B_TEST_1))
    assert_equal(4, @solver.manhattan_priority(B_TEST_2))
    assert_equal(3, @solver.manhattan_priority(B_TEST_3))
    assert_equal(0, @solver.manhattan_priority(B_FINAL))
  end

  def test_euclidean_priority
    Buckets::BucketSolver.send(:public, :euclidean_priority)
    assert_equal(7, @solver.euclidean_priority(B_EMPTY))
    assert_equal(3, @solver.euclidean_priority(B_FULL))

    assert_equal(5, @solver.euclidean_priority(B_TEST_1))
    assert_equal(2, @solver.euclidean_priority(B_TEST_2))
    assert_equal(2, @solver.euclidean_priority(B_TEST_3))
    assert_equal(0, @solver.euclidean_priority(B_FINAL))
  end

  def test_score_priority
    Buckets::BucketSolver.send(:public, :score_priority)
    assert_equal(0, @solver.score_priority(B_EMPTY))
    assert_equal(10,@solver.score_priority(B_FULL))

    assert_equal(6, @solver.score_priority(B_TEST_1))
    assert_equal(12,@solver.score_priority(B_TEST_2))
    assert_equal(14,@solver.score_priority(B_TEST_3))
    assert_equal(21,@solver.score_priority(B_FINAL))
  end

  def test_is_solution
    Buckets::BucketSolver.send(:public, :is_solution?)
    assert_equal(true,  @solver.is_solution?(B_FINAL))
    assert_equal(false, @solver.is_solution?(B_TEST_3))
  end



  def test_init_algorithm
    Buckets::BucketSolver.send(:public, :init_algorithm)

    algortihm_assertion(:bfs, B_INIT, B_TEST_2, B_FINAL, B_TEST_1, B_TEST_3)
    algortihm_assertion(:dfs, B_TEST_3, B_TEST_1, B_FINAL, B_TEST_2, B_INIT)
    algortihm_assertion(:man, B_FINAL, B_TEST_3, B_TEST_2, B_TEST_1, B_INIT)
    algortihm_assertion(:euc, B_FINAL, B_TEST_2, B_TEST_3, B_TEST_1, B_INIT)
    algortihm_assertion(:sco, B_FINAL, B_TEST_3, B_TEST_2, B_TEST_1, B_INIT)
  end

  def algortihm_assertion(method, first, second, third, fourth, fifth)
    @solver.init_algorithm(method, B_INIT)
    @solver.get_add_state.call(B_TEST_2)
    @solver.get_add_state.call(B_FINAL)
    @solver.get_add_state.call(B_TEST_1)
    @solver.get_add_state.call(B_TEST_3)

    assert_equal(first,  @solver.get_get_state.call)
    assert_equal(second, @solver.get_get_state.call)
    assert_equal(third,  @solver.get_get_state.call)
    assert_equal(fourth, @solver.get_get_state.call)
    assert_equal(fifth,  @solver.get_get_state.call)
  end


  
  def test_solve
    solver = Buckets::BucketSolver.new(Buckets::Instance.new(1, 5, [14,10,6,2,8], [0,0,1,0,0], [12,6,4,1,8]), :sco)
    solver.solve
    assert_equal(13, Buckets::CsvResultsWriter.results[0].result[2])
  end

  def teardown
    Buckets::CsvResultsWriter.results.clear
  end
end
