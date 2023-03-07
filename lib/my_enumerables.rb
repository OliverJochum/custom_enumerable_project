module Enumerable
  # Your code goes here
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  def my_each
    if block_given?
      for element in self
        yield element
      end
    end
    return self
  end

  def my_each_with_index
    if block_given?
      i = 0
      for element in self
        yield element, i
        i += 1
      end
    end
    self
  end
end
