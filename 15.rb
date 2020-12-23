# Have an array that fills up with all the numbers being said
# Initialize it to the starting numbers
# Have a separate object that saves the most recent instance that each number has appeared in the array
# Determine the next number to push by noting whether the current last number is unique or not (if it appears as a key in the object)
# If unique, push "0"
# If not unique, look up the value of the key, calculate the difference between that and the latest index,
# and push that difference + update the value for that key
# Iterate until 2020

require "pry"

class Exercise15
  test_start = [0, 3, 6]
  real_start = [6, 19, 0, 5, 7, 13, 1]

  # NAIVE WAY, WITH TIME COMPLEXITY OF N^2
  # def self.compute_next_naive(arr)
  #   (1...arr.length).each do |ind|
  #     if arr.reverse[ind] == arr.reverse[0]
  #       return ind
  #     end
  #   end
  #   0
  # end

  def self.compute_next(prev, current_ind, occurrences)
    diff = occurrences[prev] ? current_ind - occurrences[prev] : 0
    occurrences[prev] = current_ind
    diff
  end

  def self.play_game(start, play_until)
    n = start.length
    occurrences = Hash.new
    # Do not update the occurrences hash with n-1 until we've had a chance to evaluate whether the number at index n-1 it's unique
    (0..n - 2).each do |num|
      occurrences[start[num]] = num
    end
    (n...play_until).each do |num|
      start.push(compute_next(start[-1], start.length - 1, occurrences))
    end
    puts "The #{start.length}-th number is #{start[-1]}"
  end

  play_game(real_start, 2020) # Output: The 2020-th number is 468
  play_game(real_start, 30000000) # Output: The 30000000-th number is 1801753
end
