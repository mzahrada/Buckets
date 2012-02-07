class String
  # Returns +true+ if String is positive Integer.
  # ---
  # * Returns::
  #   - +true+ if _self_ String is positive Integer
  def is_positive_int?
    return self.match(/^\d+$/) == nil ? false : true   # /\A[+-]?\d+?(\.\d+)?\Z/ for floats
  end
end
