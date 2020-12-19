
require_relative "exercises"

class Exercise1 < Exercises

  # Read file
  # Use new line separator to create an array of the numbers
  # Convert numbers from string to integer
  # Now we have the array of numbers we need to iterate through

  arr_str = open("01-input.txt").read.split("\n")
  my_arr = arr_str.map do |str|
    str.to_i
  end

  def self.find_product(arr, nums_to_sum, desired_sum)
    matches = find_matches(arr, nums_to_sum, desired_sum)
    if matches
      puts "The product of #{matches.join(', ')} is #{matches.reduce(:*)}"
    else
      puts "No solution found"
    end
  end

  find_product(my_arr, 2, 2020)
  find_product(my_arr, 3, 2020)

  # Output
  # The product of 618, 1402 is 866436
  # The product of 545, 547, 928 is 276650720

end
