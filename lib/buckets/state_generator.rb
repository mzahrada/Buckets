module Buckets
  # Class for generating states. There are possible 3 operations with bucket:
  # * +fill+ bucket
  # * +empty+ bucket
  # * +pour+ water from one to another bucket
  class StateGenerator
    # Creates new StateGenerator, sets its _instance_ and _root_ state.
    # ---
    # * Args::
    #   - +Instance+ _instance_ bucket problem instance
    def initialize(instance)
      @instance = instance
      set_state(instance.init_capacities)
    end

    # Sets states and inits data (indexes, operation).
    # ---
    # * Args::
    #   - <tt>Integer[]</tt> _state_ buckets state
    def set_state(state)
      @original_state = state
      @first_index = 0
      @second_index = 1
      @operation = :fill
    end

    # Tests if generator's actual state has next state.
    # ---
    # * Returns::
    #   - +true+ if generator's actual state has next
    def has_next_state?
      return @operation != :nop
    end

    # Gets next state of generator's actual state.
    # ---
    # * Returns::
    #   - <tt>Integer[]</tt> _new_state_ new state
    def get_next_state
      new_state = @original_state.clone
      case @operation
        when :nop
          return nil
        when :fill
          if new_state[@first_index] == @instance.capacities[@first_index]
            new_state = nil
          else
            new_state = fill_bucket(new_state, @first_index)
          end
        when :empty
          if new_state[@first_index] > 0
            new_state = empty_bucket(new_state, @first_index)
          else
            new_state = nil
          end
        when :pour
          if new_state[@second_index] < @instance.capacities[@second_index] && new_state[@first_index] > 0
            new_state = pour_buckets(new_state, @first_index, @second_index)
          else
            new_state = nil
          end
      end
      count_next_index()
      return new_state
    end

    private

      # Fills bucket on _index_ position.
      # ---
      # * Args::
      #   - <tt>Integer[]</tt> _bucket_state_ state
      #   - +Integer+ _index_ position of bucket to be filled
      def fill_bucket(bucket_state, index)
        bucket_state[index] = @instance.capacities[index]
        return bucket_state
      end

      # Makes bucket on _index_ position empty.
      # ---
      # * Args::
      #   - <tt>Integer[]</tt> _bucket_state_ state
      #   - +Integer+ _index_ position of bucket to be emptied
      def empty_bucket(bucket_state, index)
        bucket_state[index] = 0
        return bucket_state
      end

      # Pours water _from_ bucket _to_ another one.
      # ---
      # * Args::
      #   - <tt>Integer[]</tt> _bucket_state_ state
      #   - +Integer+ _from_ position of source bucket
      #   - +Integer+ _to_ position of target bucket
      def pour_buckets(bucket_state, from, to)
        value = [bucket_state[from], @instance.capacities[to] - bucket_state[to]].min
        bucket_state[from] -= value
        bucket_state[to] += value
        return bucket_state
      end

      # Counts next position of bucket to be manipulated with
      # and switches to another operation.
      def count_next_index()
        if @operation == :pour
          if @second_index + 1 >= @original_state.size
            @second_index = 0
            @first_index += 1
          else
            @second_index += @second_index + 1 == @first_index ? 2 : 1
          end
          if @first_index + 1 == @original_state.size && @second_index + 1 >= @original_state.size
            @operation = :nop
          end
        else
          if @first_index + 1 < @original_state.size
            @first_index += 1
          else
            @first_index = 0
            @operation = @operation == :fill ? :empty : :pour
          end
        end
      end
  end
end
