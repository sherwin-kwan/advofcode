file = "./05.txt"

data = File.open(file).each_line.map{_1.strip.split(" -> ")}
sea = Array.new(1000){Array.new(1000){0}}
data.each do |vent_line|
  x1, y1 = vent_line[0].split(",").map(&:to_i)
  x2, y2 = vent_line[1].split(",").map(&:to_i)
  x_coord, y_coord = [x1, y1]
  next if x2 != x1 && y2 != y1 # Comment out this line for Part 2
  loop do
    sea[x_coord][y_coord] += 1
    break if x_coord == x2 && y_coord == y2
    x_coord += x2 <=> x1 # Returns +1, -1, or 0 depending whether x2 > x1 or x1 > x2
    y_coord += y2 <=> y1
  end
end

puts sea.flatten.count{_1 >= 2}