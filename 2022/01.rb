file = ARGV[0] || "./01.txt"

input = File.open(file).read.split("\n\n").map{|elf_food| elf_food.split("\n").map(&:to_i)}

def highest_sum(arr)
  arr.map(&:sum).max
end

def highest_sum_2(arr)
  arr.map(&:sum).sort.last(3).sum
end

puts "Part 1: #{highest_sum(input)}"
puts "Part 2: #{highest_sum_2(input)}"