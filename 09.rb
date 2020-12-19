# Begin by parsing the input file into an array
# Iterate through each number after the preamble to determine if they are valid
# Use the function from Day 1 to determine whether two numbers of the previous 25 exist which sum to the number under investigation
# Break the loop when a number is found which isn't the sum of any two of the previous 25 numbers
# Return the current number

# PART 2:
# Iterate from n = 3 onwards indefinitely (until the problem is solved) [from previous part, there can't be a solution for n = 2]
# For each n, test if there is a sum of contiguous numbers that reaches that number
# If true, end the loop and return the sum of the smallest and largest number of the n numbers

require_relative "exercises"

class Exercise9 < Exercises
  data = parse_file("09-input.txt", "\n", false).map {|num| num.to_i}
  data_test = parse_file("09-test.txt", "\n", false).map {|num| num.to_i}

  def self.find_outlier(arr, premable_length)
    (premable_length...arr.length).each do |ind|
      unless find_matches(arr[ind - premable_length...ind], 2, arr[ind], true)
        puts "#{arr[ind]} at index #{ind} is unmatched." 
        return ind
      end
    end
  end

  def self.find_weakness(arr, index, premable_length)
    n = 3
    outlier = arr[index]
    loop do
      puts "n = #{n}"
      (0..index-n).each do |starting_index|
        if arr.slice(starting_index, n).reduce(:+) == outlier
          p arr.slice(starting_index, n)
          sorted = arr.slice(starting_index, n).sort
          puts "Weakness found: #{sorted[0]} + #{sorted[-1]} = #{sorted[0] + sorted[-1]}"
          return sorted[0] + sorted[-1]
        end
      end
      n += 1
    end
  end

  find_outlier(data_test, 5)
  find_outlier(data, 25)
  find_weakness(data, find_outlier(data, 25), 25)
end