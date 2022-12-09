$input = File.open("./08.txt").read.split("\n").map{_1.split("").map(&:to_i)}
visible = []
$rows = $input.count
$cols = $input[0].count

def check_visible(row, col)
  height = $input[row][col]
  return true unless (0..col-1).to_a.any?{$input[row][_1] >= height}
  return true unless (col+1..$cols-1).to_a.any?{$input[row][_1] >= height}
  return true unless (0..row-1).to_a.any?{$input[_1][col] >= height}
  return true unless (row+1..$rows-1).to_a.any?{$input[_1][col] >= height}
end

def scenery(row, col)
  height = $input[row][col]
  a = (block = (0..col-1).to_a.reverse.find_index{$input[row][_1] >= height}) ? block+1 : col
  b = (block = (col+1..$cols-1).to_a.find_index{$input[row][_1] >= height}) ? block+1 : $cols-col-1
  c = (block = (0..row-1).to_a.reverse.find_index{$input[_1][col] >= height}) ? block+1 : row
  d = (block = (row+1..$rows-1).to_a.find_index{$input[_1][col] >= height}) ? block+1 : $rows-row-1
  a * b * c * d
end

max_scenery = 0
(1..$rows-2).each do |row|
  (1..$cols-2).each do |col|
    visible << [row, col] if check_visible(row, col)
    max_scenery = [max_scenery, scenery(row, col)].max
  end
end

puts "Part 1: #{2*$cols+2*$rows-4+visible.count}"
puts "Part 2: #{max_scenery}"