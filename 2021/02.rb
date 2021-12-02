file = "./02.txt"

data = File.open(file).each_line.map{|l| l.split(" ")}
location = depth = aim = 0

data.each do |line|
  case line[0]
  when "forward"
    location += line[1].to_i
    depth += aim * line[1].to_i # Part 2 only
  when "down"
    aim += line[1].to_i 
    # Part 1: depth += line[1].to_i
  when "up"
    aim -= line[1].to_i
    # Part 1: depth -= line[1].to_i
  end
end

puts location * depth