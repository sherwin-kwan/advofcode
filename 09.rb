# Begin by parsing the input file into an array
# Iterate through each number after the preamble to determine if they are valid
# Use the function from Day 1 to determine whether two numbers of the previous 25 exist which sum to the number under investigation
# Break the loop when a number is found which isn't the sum of any two of the previous 25 numbers
# Return the current number

# PART 2:
# 

require_relative "exercises"

class Exercise9 < Exercises
  data = parse_file("09-input.txt", "\n", false).map {|num| num.to_i}
  data_test = parse_file("09-test.txt", "\n", false).map {|num| num.to_i}

  def self.find_outlier(arr, premable_length)
    (premable_length...arr.length).each do |ind|
      puts "#{arr[ind]} at index #{ind} is unmatched." unless find_matches(arr[ind - premable_length...ind], 2, arr[ind])
    end
  end

  find_outlier(data_test, 5)
  find_outlier(data, 25)
end