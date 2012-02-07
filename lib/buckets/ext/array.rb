require_relative 'String'

class Array

  NOT_POSITIVE_INTEGER = "'%s' is not positive number."
  
  # Converts array of strings to array of positive integers.
  # ---
  # * Raises::
  #   - _ArgumentError_ if any of String in _self_ array not positive integer
  # * Returns::
  #   - <tt>Integer[]</tt> _int_array_ array of positive integers
  def to_positive_int_array
      int_array = []
      self.each { |str|
        raise ArgumentError.new(NOT_POSITIVE_INTEGER % str) if !str.is_positive_int? #(str)
        int_array << str.to_i
      }
      return int_array
    end
end
