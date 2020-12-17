# Read file
# Use new line separator to create an array of the numbers
# Convert numbers from string to integer
# Now we have the array of numbers we need to iterate through

arr_str = open("input-01.txt").read.split("\n")
my_arr = arr_str.map do |str|
  str = str.to_i
end

# Base case: Find a single number in an array
# Recursive case: with N numbers to sum. Pick first number, then find whether there's a match for the rest of the numbers

def find_matches(arr, nums_to_sum, desired_sum)
  arr = arr.sort
  if nums_to_sum == 1
    return (arr.index(desired_sum)) ? [desired_sum] : nil;
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

def find_product(arr, nums_to_sum, desired_sum)
  matches = find_matches(arr, nums_to_sum, desired_sum)
  if matches
    puts "The product of #{matches.join(", ")} is #{matches.reduce(:*)}"
  else
    puts "No solution found"
  end
end

find_product(my_arr, 2, 2020)
find_product(my_arr, 3, 2020)

# Output
# The product of 618, 1402 is 866436
# The product of 545, 547, 928 is 276650720