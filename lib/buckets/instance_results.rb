module Buckets
  # Respresents result of bucket instance problem.
  class InstanceResults
    # Array of values which represents bucket result.
    attr_reader :result
    # Creates new InstanceResults as an array of results values.
    # ---
    # * Args::
    #   - +Integer+ _id_ instance id
    #   - +Symbol+ _method_ solving method
    #   - +Integer+ _op_count_ number of operations with bucket
    #   - +Integer+ _closed_sum_ number of closed states
    #   - +Integer+ _expanded_sum_ number of expanded states
    #   - +String+ _trace_ trace from initial to final state
    def initialize(id,method,op_count,closed_sum,expanded_sum,trace)
      @result = [id,method,op_count,closed_sum,expanded_sum,trace]
    end
  end
end
