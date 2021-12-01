file = "./01.txt"

def calc_depths(arr, increment)
  counter = 0
  (1...arr.count).each {|ind| counter += 1 if arr[ind] > arr[ind - increment]}
  puts counter
end

input = File.open(file).each_line.map(&:to_i)
calc_depths(input, 1) # Part 1: 1752
calc_depths(input, 3) # Part 2: 1781
