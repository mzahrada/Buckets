require 'algorithms'
require_relative 'state_generator'
require_relative 'csv_results_writer'
require_relative 'instance_results'
require_relative 'trace_mapper'

module Buckets
  # Solves bucket problem.
  class BucketSolver
    include Containers

    # Creates new BucketSolver, initializes problem _instance_,
    # solving _method_. Creates new TraceMapper and StateGenerator.
    # Sets solving algorithm.
    # ---
    # * Args::
    #   - +Instance+ _instance_ bucket problem instance
    #   - +Symbol+ _method_ solving method
    def initialize(instance, method)
      @instance = instance
      @method = method
      @trace_mapper = TraceMapper.new(@instance.init_capacities)

      init_algorithm(method, instance.init_capacities)
      @state_generator = StateGenerator.new(instance)
    end

    # Solves bucket problem, adds result to CsvResultsWriter.
    def solve
      solution = nil
      closed_states = {}      
      until @queue.empty? || solution
        bucket_state = @get_state.call # get bucket state from queue
        unless closed_states[bucket_state.to_s] # if bucket state not in closed states hash (already visited states)
          @state_generator.set_state(bucket_state)
          while @state_generator.has_next_state?
            if new_bucket_state = @state_generator.get_next_state # produce new buckets state
              @trace_mapper.store_state(new_bucket_state, bucket_state) unless @trace_mapper.contains_state?(new_bucket_state)  # save new state's predescing state
              (solution = new_bucket_state; break) if is_solution?(new_bucket_state)  # is solution?
              @add_state.call(new_bucket_state) unless closed_states[new_bucket_state.to_s]  # add new state to queue
            end
          end
          closed_states.store(bucket_state.to_s, bucket_state)  # save actual buckets state to closed states hash
        end
      end
      @trace_mapper.count_trace(solution)
      CsvResultsWriter.add_result(InstanceResults.new(@instance.id,@method,@trace_mapper.trace_length,closed_states.size,@queue.size + closed_states.size,@trace_mapper.trace))
    end

    private

      # Depending on solving _method_ - inits data structure _queue_, pushes _root_ state into it
      # and sets its _get_ and _add_ methods.
      # ---
      # * Args::
      #   - +Symbol+ _method_ solving method
      #   - +Numeric[]+ _root_ root state
      def init_algorithm(method, root)
        case method
          when :bfs
            @queue = [root]                              # data structure init
            @get_state = lambda { @queue.shift }          # get object from structure method init
            @add_state = lambda { |x| @queue.push(x) }    # get object from structure method init
          when :dfs
            @queue = [root]
            @get_state = lambda { @queue.pop }
            @add_state = lambda { |x| @queue.push(x) }
          when :man
            @queue = PriorityQueue.new { |x, y| (x <=> y) == -1 }
            @get_state = lambda { @queue.pop }
            @add_state = lambda { |x|
              @queue.push(x, manhattan_priority(x))
            }
            @add_state.call(root)
          when :euc
            @queue = PriorityQueue.new { |x, y| (x <=> y) == -1 }
            @get_state = lambda { @queue.pop }
            @add_state = lambda { |x|
              @queue.push(x, euclidean_priority(x))
            }
            @add_state.call(root)
          when :sco
            @queue = PriorityQueue.new
            @get_state = lambda { @queue.pop }
            @add_state = lambda { |x|
              @queue.push(x, score_priority(x))
            }
            @add_state.call(root)
        end
      end

      # Counts manhattan priority of buckets state using manhattan distance.
      # ---
      # * Args::
      #   - <tt>Integer[]</tt> _x_ buckets state
      # * Returns::
      #   - Integer _priority_ of buckets state
      def manhattan_priority(x)
        priority = 0
        0.upto(x.size-1) { |i|
          priority += (x[i] - @instance.final_capacities[i]).abs
        }
        return priority
      end

      # Counts euclidean priority of buckets state using euclidean distance.
      # ---
      # * Args::
      #   - <tt>Integer[]</tt> _x_ buckets state
      # * Returns::
      #   - Integer _priority_ of buckets state
      def euclidean_priority(x)
        priority = 0
        0.upto(x.size-1) { |i|
          priority += (x[i] - @instance.final_capacities[i])**2
        }
        return Math.sqrt(priority).round
      end

      # Counts score priority of buckets state. Gives score:
      # - +7 when bucket filled right
      # - +5 when there is other bucket with expected amount of water
      # - +2 when bucket not fully filled or empty
      # ---
      # * Args::
      #   - <tt>Integer[]</tt> _x_ buckets state
      # * Returns::
      #   - Integer _priority_ of buckets state
      def score_priority(x)
        priority = 0
        0.upto(x.size-1) { |i|
          if x[i] == @instance.final_capacities[i]
            priority += 7
          elsif @instance.final_capacities.include?(x[i])
            priority += 5
          elsif x[i] > 0 && x[i] != @instance.capacities[i]
            priority += 2
          end
        }
        return priority
      end

      # Tests if _bucket_state_ solves buckets problem.
      # ---
      # * Args::
      #   - <tt>Integer[]</tt> _bucket_state_ buckets state
      # * Returns::
      #   - +true+ if _bucket_state_ is solutoin of buckets problem
      def is_solution?(bucket_state)
        return bucket_state == @instance.final_capacities
      end
  end
end
