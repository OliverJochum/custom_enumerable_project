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
    # if a block is given, we iterate through the array and execute the given block onto each element
    # and then return the modified array
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
    # same concept as above except the block executes both the current element and the index of said elemeent
    self
  end

  def my_select
    if block_given?
      results = []
      
      my_each { |element| results.push(element) if yield element }
      results
      # if a block is given, we use our each method to push an element to the results array
      # if the given block is executed for that element and then return the 'selected' results
    end
  end

  def my_all?(pattern = nil)
    expr = block_given? ? ->(elem) { yield elem } : ->(elem) { pattern === elem }
    my_each { |elem| return false unless expr.call(elem) }
    true

    #when expr is called, if a block is given, the block is executed on the element, the lambda will return true or false
    # if no block is given, the element is matched against passed pattern, this will return true or false
    # the method returns false as soon as the value from the expr call is true once 
    # (when one element does not match whatever pattern is passed) 
    # if false is never returned from the my_each method the next return is true(if all elements match)
  end

  def my_any?(pattern = nil)
    expr = block_given? ? ->(elem) { yield elem } : ->(elem) { pattern === elem }
    my_each { |elem| return true if expr.call(elem) }
    false
    # when expr is called, if a block is given execute the block on the element, the lambda will return true or false
    # if a block is not given, match the given pattern against the element, the lambda will return true or false
    # if the expr call returns true, my_any? returns true, because at least one element matches
    # if true is never returned, false is returned, because no element matches
  end

  def my_none?(pattern = nil)
    if block_given?
      expr = ->(elem) { yield elem }
    else
      expr = pattern ? ->(elem) { pattern === elem } : ->(elem) { false ^ elem }
    end
    my_each { |elem| return false if expr.call(elem) }
    true

    # when expr is called, if a block is given, execute the block on the element
    # if no block is given expr is defined differently
    # if no block is given, when expr is called, if a pattern argument was provided, the element is matched against the pattern
    # if no pattenr argument was provided, the lambda returns the result of false XOR the element
    # this is because none? is checking for the value 'true' in the array in this case
    # if the call returns true then the element has been matched which makes none? false
    # if my_each never returns false, none of the elements must match, hence true is returned
  end

  def my_count(item = nil)
    return size if item.nil? && !block_given? #if no block is given and if the method is used without an argument it returns the size of the array
    count = 0
    #when expr is called it checks whether a block is given or not
    #if a block is given, the count is incremented if the block is executed
    #if a block is not given, each item in the array is matched against the argument item, the count is incremented if the pattern matches
    # the count is returned after each element is gone through
    expr = block_given? ? ->(elem) { count += 1 if yield elem } : ->(elem) { count += 1 if item === elem } 
    my_each { |elem| expr.call(elem) }
    count
  end

  def my_map(block = nil)
    return self unless block_given?
    # if no block is given, return the array

    result = []
    expr = ->(elem){yield elem} if block_given?

    # when expr is called, if a block is given, the block is executed for the element
    # the returned value is then pushed to the result array
    # the new 'result' array is returned

    my_each{|elem| result.push(expr.call(elem))}
    result
  end

  def my_inject(*args)
    #checks if or which arguments were provided and assigns them to sym and initial
    case args
      in [a] if a.is_a? Symbol
        sym = a
      in [a] if a.is_a? Object
        initial = a
      in [a,b]
        initial = a
        sym = b
      else
        initial = nil
        sym = nil 
      end



      memo = initial || first

      if block_given?
        my_each_with_index do |ele, i|
          next if initial.nil? && i.zero?
          memo = yield(memo,ele)
        end
      elsif sym
        my_each_with_index do |ele, i|
          next if initial.nil? && i.zero?

          memo = memo.send(sym, ele)
        end
      end

      memo


  end
end
