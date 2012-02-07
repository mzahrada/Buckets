module Buckets
  # Describes an instance of bucket problem.
  class Instance

    ITEMS_COUNT_ERROR = "Not correct number of buckets provided."
    CAPACITIES_NOT_CORRECT = "Bucket capacity outweighed."

    # +Integer+ instance id
    attr_accessor :id
    # +Integer+ number of buckets in instance
    attr_accessor :count
    # <tt>Integer[]</tt>  buckets capacities (max possible capacity of each bucket)
    attr_accessor :capacities
    # <tt>Integer[]</tt> buckets initial capacities (can be some water in every bucket)
    attr_accessor :init_capacities
    # <tt>Integer[]</tt> bucket final capacities (amount of water of each bucket we want to reach)
    attr_accessor :final_capacities

    # Creates new Instance object.
    # ---
    # * Args::
    #   - +Integer+ _id_ instance id
    #   - +Integer+ _count_ number of buckets in instance
    #   - <tt>Integer[]</tt> _capacities_ buckets capacities (max possible capacity of each bucket)
    #   - <tt>Integer[]</tt> _init_capacities_ buckets initial capacities (can be some water in every bucket)
    #   - <tt>Integer[]</tt> _final_capacities_ bucket final capacities (amount of water of each bucket we want to reach)
    def initialize(id, count, capacities, init_capacities, final_capacities)
      raise ArgumentError.new(ITEMS_COUNT_ERROR) if capacities.size != count || init_capacities.size != count || final_capacities.size != count
      raise ArgumentError.new(CAPACITIES_NOT_CORRECT) if !capacities_correct?(capacities, init_capacities, final_capacities)
      @id = id
      @count = count
      @capacities = capacities
      @init_capacities = init_capacities
      @final_capacities = final_capacities
    end

    # Tests if capacities of _init_ or _final_ state are not over buckets _max_ capacities.
    # ---
    # * Args::
    #   - <tt>Integer[]</tt> _max_ buckets max capacities
    #   - <tt>Integer[]</tt> _init_ buckets initial capacities
    #   - <tt>Integer[]</tt> _final_ bucket final capacities
    # * Returns::
    #   - +true+ if _init_ or _final_ not over _max_ capacities
    def capacities_correct?(max, init, final)
      correct = true
      0.upto(max.size-1) { |i|
        correct = false if max[i] < init[i] || max[i] < final[i]
      }
      return correct
    end
  end
end
