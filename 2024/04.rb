big_hash = {}
puzzle = File.open("04.txt").read.split("\n")
puzzle.each_with_index do |line, x|
  line.chars.each_with_index do |char, y|
    big_hash[x+y.i] = char
  end
end

count = 0
(0...puzzle.count).each do |x|
  (0...puzzle.count).each do |y|
    next unless big_hash[x+y.i] == "X"
    count += 1 if [big_hash[(x+1)+(y+1).i], big_hash[(x+2)+(y+2).i], big_hash[(x+3)+(y+3).i]].compact == ["M","A", "S"]
    count += 1 if [big_hash[(x+1)+(y-1).i], big_hash[(x+2)+(y-2).i], big_hash[(x+3)+(y-3).i]].compact == ["M","A", "S"]
    count += 1 if [big_hash[(x-1)+(y+1).i], big_hash[(x-2)+(y+2).i], big_hash[(x-3)+(y+3).i]].compact == ["M","A", "S"]
    count += 1 if [big_hash[(x-1)+(y-1).i], big_hash[(x-2)+(y-2).i], big_hash[(x-3)+(y-3).i]].compact == ["M","A", "S"]
    count += 1 if [big_hash[(x)+(y+1).i], big_hash[(x)+(y+2).i], big_hash[(x)+(y+3).i]].compact == ["M","A", "S"]
    count += 1 if [big_hash[(x)+(y-1).i], big_hash[(x)+(y-2).i], big_hash[(x)+(y-3).i]].compact == ["M","A", "S"]
    count += 1 if [big_hash[(x+1)+(y).i], big_hash[(x+2)+(y).i], big_hash[(x+3)+(y).i]].compact == ["M","A", "S"]
    count += 1 if [big_hash[(x-1)+(y).i], big_hash[(x-2)+(y).i], big_hash[(x-3)+(y).i]].compact == ["M","A", "S"]
  end
end
puts "Part 1: #{count}"

count = 0
(1...puzzle.count - 1).each do |x|
  (1...puzzle.count - 1).each do |y|
    next unless big_hash[x+y.i] == "A"
    if [big_hash[(x-1)+(y-1).i], big_hash[(x+1)+(y+1).i]].sort == ["M", "S"]
      if [big_hash[(x-1)+(y+1).i], big_hash[(x+1)+(y-1).i]].sort == ["M", "S"]
        count += 1
      end
    end
  end
end
puts "Part 2: #{count}"

# Alternate Part 1 solution with regex
puzzle_transposed = puzzle.map{_1.split("")}.transpose.map{_1.join("")}
puzzle_diagonal_right_down = []
puzzle_diagonal_left_down = []
# Can do this because we know the puzzle is square (I checked)
diagonal_count = puzzle.count + puzzle_transposed.count - 1
last_index = puzzle.count - 1
(0...diagonal_count).each do |n|
  row = n <= last_index ? last_index - n : 0
  col = n <= last_index ? 0 : n - last_index
  row2 = n <= last_index ? 0 : n - last_index
  col2 = n <= last_index ? n : last_index
  arr = []
  arr2 = []
  [n + 1, (diagonal_count - n) + 1].min.times do
    arr << big_hash[row +col.i]
    arr2 << big_hash[row2 + col2.i]
    row += 1
    row2 += 1
    col += 1
    col2 -= 1
  end
  puzzle_diagonal_right_down << arr.join("")
  puzzle_diagonal_left_down << arr2.join("")
end

count = 0
# Horizontal
(0...puzzle.count).each do |row_num|
  count += puzzle[row_num].scan(/XMAS/).count
  count += puzzle[row_num].scan(/SAMX/).count
end
# Vertical
(0...puzzle_transposed.count).each do |col_num|
  count += puzzle_transposed[col_num].scan(/XMAS/).count
  count += puzzle_transposed[col_num].scan(/SAMX/).count
end
# Right Diagonals
(0...puzzle_diagonal_right_down.count).each do |diag_num|
  count += puzzle_diagonal_right_down[diag_num].scan(/XMAS/).count
  count += puzzle_diagonal_right_down[diag_num].scan(/SAMX/).count
end
# Left Diagonals
(0...puzzle_diagonal_left_down.count).each do |diag_num|
  count += puzzle_diagonal_left_down[diag_num].scan(/XMAS/).count
  count += puzzle_diagonal_left_down[diag_num].scan(/SAMX/).count
end
puts "Part 1: #{count}"
