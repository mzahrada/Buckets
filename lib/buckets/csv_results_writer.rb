module Buckets
  # Class for recording results and writing them to CSV file.
  # ---
  # Output (2 instances, 2 solving methods):
  # 
  #     id;method;bucket-operation-count;closed-states-sum;expanded-states-sum;trace
  #     11;bfs;10;8921;10219;first >> 0,0,1,0,0 >> 14,0,1,0,0 >> 14,10,1,0,0 >> 12,10,1,2,0 >> 12,10,1,0,0 >> 12,10,0,1,0 >> 12,4,6,1,0 >> 12,0,6,1,4 >> 12,6,0,1,4 >> 12,6,4,1,0 >> 12,6,4,1,8
  #     11;dfs;22;3735;21317;first >> 0,0,1,0,0 >> 1,0,0,0,0 >> 1,0,0,0,8 >> 1,0,6,0,2 >> 1,6,0,0,2 >> 0,6,0,0,3 >> 6,0,0,0,3 >> 4,0,0,2,3 >> 0,0,0,2,3 >> 0,2,0,0,3 >> 0,2,0,2,1 >> 0,4,0,0,1 >> 0,0,4,0,1 >> 14,0,4,0,1 >> 12,0,6,0,1 >> 12,6,0,0,1 >> 10,6,0,2,1 >> 10,6,2,0,1 >> 14,6,2,0,1 >> 12,6,2,2,1 >> 12,6,4,0,1 >> 12,6,4,1,0 >> 12,6,4,1,8
  #     12;bfs;8;5819;19162;first >> 0,0,1,0,0 >> 14,0,1,0,0 >> 14,10,1,0,0 >> 14,10,1,2,0 >> 14,10,1,0,2 >> 14,10,0,1,2 >> 14,4,6,1,2 >> 14,4,5,2,2 >> 14,4,5,0,4
  #     12;dfs;19;5263;34963;first >> 0,0,1,0,0 >> 1,0,0,0,0 >> 1,0,0,0,8 >> 1,0,0,2,6 >> 1,2,0,0,6 >> 1,2,0,2,4 >> 0,3,0,2,4 >> 0,0,3,2,4 >> 0,0,3,2,0 >> 2,0,3,0,0 >> 2,10,3,0,0 >> 2,8,3,2,0 >> 4,8,3,0,0 >> 4,8,3,2,0 >> 4,8,3,0,2 >> 4,6,3,2,2 >> 4,6,3,0,4 >> 4,4,3,2,4 >> 4,4,5,0,4 >> 14,4,5,0,4
  #
  # Row description::
  # - <tt>11</tt> .. instance id
  # - <tt>bfs</tt> .. solution method
  # - <tt>10</tt> .. number of operations performed with buckets
  # - <tt>8921</tt> .. number of closed states
  # - <tt>10219</tt> .. number of expanded states
  # - <tt>first >> 0,0,1,0,0 >> 14,0,1,0,0 >> </tt> .. trace from initial to final state
  class CsvResultsWriter
    # CSV file value delimiter.
    CSV_DELIMITER = ";"
    # CSV file header.
    CSV_HEADER = "id;method;bucket-operation-count;closed-states-sum;expanded-states-sum;trace\n"
    
    @@results = []

    # Adds instance results to results list.
    # ---
    # * Args::
    #   - +InstanceResults+ _instance_results_ array with results data
    def self.add_result(instance_results)
      @@results << instance_results
    end

    # Writes _results_ to file _outfile_ in CSV format.
    # ---
    # * Args::
    #   - +String+ _outfile_ name of output file
    def self.write_results(outfile)
      File.open(outfile, "w") { |i|
        i << CSV_HEADER
        @@results.each { |item|
          i << item.result.join(CSV_DELIMITER) + "\n"
        }
      }
    end

    # Returns class variable _results_.
    def self.results
      return @@results
    end
  end
end
