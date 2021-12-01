file = "./01.txt"

# Part 1
arr = File.open(file).each_line.map(&:to_i)
counter = 0
(1...arr.count).each {|ind| counter += 1 if arr[ind] > arr[ind - 1]}
puts counter

# Part 2
counter = 0
(3...arr.count).each {|ind| counter += 1 if arr[ind] > arr[ind - 3] }
puts counter