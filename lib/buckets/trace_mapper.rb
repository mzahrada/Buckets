module Buckets
  # Used for mapping state trace - from initial to solution buckets state.
  class TraceMapper
    # +Hash+ for recording state's predescing state |key,value| >> |state, predescingState|
    attr_accessor :trace_map
    # +String+ trace from initial state to solution state
    attr_reader :trace
    # +Integer+ length of trace
    attr_reader :trace_length

    # Creates new TrackMapper. Records initial state.
    # ---
    # * Args::
    #   - <tt>Integer[]</tt> _init_state_ initial buckets state
    def initialize(init_state)
      @trace_map = {}
      @trace_map.store(init_state, "first")
    end

    # Stores state to hash map where state is key and predecesing state is value.
    # ---
    # * Args::
    #   - <tt>Integer[]</tt> _state_ buckets state
    #   - <tt>Integer[]</tt> _predecessor_ predecesing state
    def store_state(state, predecessor)
      @trace_map.store(state, predecessor)
    end

    # Tests if _trace_map_ contains _state_.
    # ---
    # * Args::
    #   - <tt>Integer[]</tt> _state_ we test
    # * Returns::
    #   - +true+ if _trace_map_ contains _state_
    def contains_state?(state)
      return @trace_map[state] == nil ? false : true
    end

    # Returns predecessor of _state_ from _trace_map_.
    # ---
    # * Args::
    #   - <tt>Integer[]</tt> _state_ which predecessor we want
    # * Returns::
    #   - <tt>Integer[]</tt> predecesing state of _state_
    def get_predecessor(state)
      return @trace_map[state]
    end

    # Count trace from initial state to solution state
    # ---
    # * Args::
    #   - <tt>Integer[]</tt> _solution_ buckets state
    def count_trace(solution)
      @trace = solution.join(",")
      state = solution
      @trace_length = -1
      while get_predecessor(state)
        state = get_predecessor(state)
        @trace = (state != "first" ? state.join(",") : "first") + " >> " + @trace
        @trace_length += 1
      end
    end
  end
end
