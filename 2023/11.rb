galaxies = []
new_rows = []
new_cols = []
rows = File.open("./11.txt").read.split("\n")
height = rows.count
width = rows[0].length
rows.each_with_index do |row, x|
  row.chars.each_with_index do |char, y|
    galaxies.push(x + y.i) if char == "#"
  end
end
row_counter = 0
(0..height).each do |row_num|
  new_rows[row_num] = row_counter
  row_counter += 1
  row_counter += 999999 unless galaxies.map(&:real).any?{_1 == row_num}
end
col_counter = 0
(0..width).each do |col_num|
  new_cols[col_num] = col_counter
  col_counter += 1
  col_counter += 999999 unless galaxies.map(&:imaginary).any?{_1 == col_num}
end
total = galaxies.combination(2).map{|a, b| (new_rows[b.real] - new_rows[a.real]).abs + (new_cols[b.imaginary] - new_cols[a.imaginary]).abs}.sum
puts total