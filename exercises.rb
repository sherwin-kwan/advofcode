require 'pry'

# Master class with methods for all exercises
class Exercises
  def self.parse_file(fn, separator, log)
    data = open(fn).read.split(separator)
    p data if log
    data
  end

  # Used for exercises 1 and 9
  # Base case: Find a single number in an array
  # Recursive case: with N numbers to sum. Pick first number, then find whether there's a match for the rest of the numbers

  def self.find_matches(arr, nums_to_sum, desired_sum, negatives = false)
    arr = arr.sort
    # Remove all numbers in the array higher than the desired sum, if there are no negative numbers. Improves performance if the array
    # contains a significant chunk of numbers greater than the desired sum.
    unless negatives
      index_to_slice_until = arr.length
      (0...arr.length).each do |ind|
        if arr[ind] > desired_sum
          index_to_slice_until = ind 
          break
        end
      end
      arr = arr[0...index_to_slice_until]
    end
    if nums_to_sum == 1
      return (arr.index desired_sum) ? [desired_sum] : nil
    else
      arr.each do |num|
        potential_matches = find_matches(arr, nums_to_sum - 1, desired_sum - num)
        if potential_matches
          return [num].concat potential_matches
        elsif num > (desired_sum / nums_to_sum) # If you are summing 2 numbers, a match will be found by the time you get to half of desired sum
          return nil
        end
      end
    end
  end
end
