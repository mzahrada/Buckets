require_relative 'Instance'
require_relative 'ext/Array'

module Buckets
  # Class for reading bucket instances from file.
  # ---
  # Expected input:
  #
  #     11 5 14 10  6  2  8  0  0  1  0  0 12  6  4  1  8   .. instance 1
  #     12 5 14 10  6  2  8  0  0  1  0  0 14  4  5  0  4   .. instance 2
  #     13 5 14 10  6  2  8  0  0  1  0  0 12  6  6  2  4   .. instance 3
  #
  # Instance 1: input description::
  # - <tt>11</tt> .. instance id
  # - <tt>5</tt> .. instance size / number of buckets
  # - <tt>14 10  6  2  8</tt> .. buckets capacities
  # - <tt>0  0  1  0  0</tt> .. buckets initial state
  # - <tt>12  6  4  1  8</tt> .. buckets final state
  class InputReader

    INPUT_READER_ERROR = "Error while reading input file (row %s): "
    INPUT_ROW_ERROR = "Not correct number of items in row."

    # Parses input file and creates list of bucket instances and returns them.
    # ---
    # * Args::
    #   - +String+ _filename_ input file name
    # * Returns::
    #   - <tt>Instance[]</tt> _instance_list_ list of bucket problem instances
    def self.get_instances(filename)
      @@file = File.open(filename, "r")
      instance_list = []
      row = 1
      @@file.each_line { |line|
        begin
          int_array = line.split(" ").to_positive_int_array

          x = int_array[1]   # bucket count
          raise ArgumentError.new(INPUT_ROW_ERROR) if int_array.size != x*3+2

          instance_list << Instance.new(int_array[0], x, int_array[2..x+1], int_array[x+2..2*x+1], int_array[2*x+2..3*x+1])
          row += 1
        rescue ArgumentError => e
          raise ArgumentError.new(INPUT_READER_ERROR % row + e.message)
        end
      }
      return instance_list
    end
  end
end