data = open("./13.txt").read.split("\n\n")
marked = data[0].split("\n").map{_1.split(",").map(&:to_i)}
folds = data[1].split("\n").map{_1.gsub("fold along ", "").split("=")}

folds.each_with_index do |fold, i|
  axis, loc = fold
  if axis == "x"
    marked.each_with_index{|val, i| marked[i] = [2 * loc.to_i - val.first, val.last] if val.first > loc.to_i}
  else
    marked.each_with_index{|val, i| marked[i] = [val.first, 2 * loc.to_i - val.last] if val.last > loc.to_i}
  end
  marked.uniq!
  puts "Part 1: #{marked.count}" if i == 0
end
max_x, max_y = marked.map(&:first).max, marked.map(&:last).max  
output = File.open("./13-output.txt", "w")
[*0..max_y].each do |y|
  [*0..max_x].each do |x|
    output << (marked.include?([x, y]) ? "*" : " ")
  end
  output << "\n"
end
# Go to "13-output.txt" to read the solution to Part 2