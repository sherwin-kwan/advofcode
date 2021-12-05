file = "./05.txt"

data = File.open(file).each_line.map{|line| line.strip.split(" -> ")}
sea = Array.new(1000){Array.new(1000){0}}
data.each do |vent_line|
  x1, y1 = vent_line[0].split(",").map(&:to_i)
  x2, y2 = vent_line[1].split(",").map(&:to_i)
  x_coord, y_coord = [x1, y1]
  x_increment = x2 > x1 ? 1 : x1 > x2 ? -1 : 0
  y_increment = y2 > y1 ? 1 : y1 > y2 ? -1 : 0
  loop do
    sea[x_coord][y_coord] += 1
    break if x_coord == x2 && y_coord == y2
    x_coord += x_increment
    y_coord += y_increment
  end
end

puts sea.flatten.filter{_1 >= 2}.length