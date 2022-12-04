file = "./02-test.txt"

input = File.open(file).read.split("\n")

def score(line)
  case line
  when "A X"
    4
  when "A Y"
    8
  when "A Z"
    3
  when "B X"
    1
  when "B Y"
    5
  when "B Z"
    9
  when "C X"
    7
  when "C Y"
    2
  when "C Z"
    6
  else
    raise "Something wrong"
  end
end

def score2(line)
  case line
  when "A X"
    3
  when "A Y"
    4
  when "A Z"
    8
  when "B X"
    1
  when "B Y"
    5
  when "B Z"
    9
  when "C X"
    2
  when "C Y"
    6
  when "C Z"
    7
  else
    raise "Something wrong"
  end
end

puts "Part 1: #{input.map{|l| score(l)}.sum}"
puts "Part 2: #{input.map{|l| score2(l)}.sum}"