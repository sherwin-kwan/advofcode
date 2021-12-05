file = "./05.txt"

data = File.open(file).each_line.map{|line| line.strip.split(" -> ")}
master = Array.new(1000){Array.new(1000){0}}

data.each do |vent_line|
  x1, y1 = vent_line[0].split(",").map(&:to_i)
  x2, y2 = vent_line[1].split(",").map(&:to_i)
  if x1 == x2
    if y2 > y1
      (y1..y2).each do |y_coord|
        master[x1][y_coord] += 1
      end
    else
      (y2..y1).each do |y_coord|
        master[x1][y_coord] += 1
      end
    end
  elsif y1 == y2
    if x2 > x1
      (x1..x2).each do |x_coord|
        master[x_coord][y1] += 1
      end
    else
      (x2..x1).each do |x_coord|
        master[x_coord][y1] += 1
      end
    end
  else 
    # Diagonal lines
    if x2 > x1 && y2 > y1
      y_coord = y1
      (x1..x2).each do |x_coord|
        master[x_coord][y_coord] += 1
        y_coord += 1
      end
    elsif x2 > x1 && y1 > y2
      y_coord = y1
      (x1..x2).each do |x_coord|
        master[x_coord][y_coord] += 1
        y_coord -= 1
      end
    elsif x1 > x2 && y2 > y1
      y_coord = y2
      (x2..x1).each do |x_coord|
        master[x_coord][y_coord] += 1
        y_coord -= 1
      end
    elsif x1 > x2 && y1 > y2
      y_coord = y2
      (x2..x1).each do |x_coord|
        master[x_coord][y_coord] += 1
        y_coord += 1
      end
    end
  end
end

puts master.flatten.filter{|cell| cell >= 2}.length

# 869 / 475 on Day 5 leaderboard