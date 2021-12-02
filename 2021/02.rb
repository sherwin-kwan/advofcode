file = "./02.txt"

data = File.open(file).each_line.map{|l| [l.split(" ").first, l.split(" ").last.to_i]}
location = depth = aim = 0
data.each do |line|
  if line[0] == "forward"
    location += line[1]
    depth += aim * line[1] # Part 2 only
  else
    adjust = line[0] == "down" ? line[1] : -line[1]
    aim += adjust
  end
end

puts location * depth