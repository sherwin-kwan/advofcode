input = File.open("./04.txt").read.split("\n")

def arrs(line)
  line.gsub("-","..").split(",").map{|str| eval(str).to_a}
end

def part1(a, b)
  [a-b, b-a].include?([])
end

def part2(a, b)
  a.intersection(b).count > 0
end

puts "Part 1: #{input.count{|line| part1(*arrs(line))}}"
puts "Part 1: #{input.count{|line| part2(*arrs(line))}}"