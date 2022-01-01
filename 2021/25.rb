data = Hash.new
open("./25-test.txt").each_line.map(&:strip).to_a.tap{data[:height] = _1.count}
  .each_with_index do |row, i|
    data[:width] = row.length if i == 0
    row.chars.each_with_index do |cell, j|
      data[i + j.i] = cell == "." ? nil : cell
    end
  end

def right_neigh(comp, data) = comp.real + ((comp.imaginary + 1) % data[:width]).i
def bottom_neigh(comp, data) = (comp.real + 1) % data[:height] + comp.imaginary.i

counter = 0
loop do
  counter += 1
  right_movements = []
  data.keys.filter{data[_1] == ">" && !data[right_neigh(_1, data)]}.each{right_movements.push(_1)} 
  right_movements.each do |key|
    data[right_neigh(key, data)] = data[key]
    data[key] = nil
  end
  down_movements = []
  data.keys.filter{data[_1] == "v" && !data[bottom_neigh(_1, data)]}.each{down_movements.push(_1)} 
  down_movements.each do |key|
    data[bottom_neigh(key, data)] = data[key]
    data[key] = nil
  end
  break if down_movements.count == 0 && right_movements.count == 0
  puts "#{counter} iterations done" if counter % 100 == 0
end
puts "Final solution: #{counter}"