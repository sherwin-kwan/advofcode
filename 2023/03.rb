require "pry"

lines = File.open("03.txt").read.split("\n")
multiply = []
other = []
numbers = {}
gears = {}
lines.each_with_index do |line, row|
  current_num = ""
  line.chars.each_with_index do |char, col|
    case char
    when /\*/
      multiply.push(row + col.i)
      if current_num != ""
        numbers[row + col.i - current_num.length.i] = current_num
        current_num = ""
      end
    when /\d/
      current_num += char
      if col == line.length - 1
        numbers[row + col.i - (current_num.length - 1).i] = current_num
        current_num = ""
      end
    when /\./
      next if current_num == ""
      numbers[row + col.i - current_num.length.i] = current_num
      current_num = ""
    else # Special character other than *
      other.push(row + col.i)
      if current_num != ""
        numbers[row + col.i - current_num.length.i] = current_num
        current_num = ""
      end
    end
  end
end

def is_symbol(pos, multiply, other, value, gears)
  if multiply.include?(pos)
    if gears[pos]
      gears[pos].push(value.to_i)
    else
      gears[pos] = [value.to_i]
    end
    return true
  end
  return other.include?(pos) ? true : false
end

def is_adjacent_to_symbol(key, value, multiply, other, gears)
  adjacents = [key - 1.i, key - 1 - 1.i, key + 1 - 1.i, key - 1, key + 1]
  (1..value.length - 1).each{ adjacents.concat([key - 1 + _1.i, key + 1 + _1.i])}
  adjacents.concat([key + value.length.i, key - 1 + value.length.i, key + 1 + value.length.i])
  return adjacents.any?{is_symbol(_1, multiply, other, value, gears)}
end

numbers_next_to_symbols = numbers.filter{|k, v| is_adjacent_to_symbol(k, v, multiply, other, gears)}.values.map(&:to_i)
puts "Part 1: #{numbers_next_to_symbols.sum}"
real_gears = gears.values.filter{_1.length == 2}
puts "Part 2: #{real_gears.map{_1.reduce(&:*)}.sum}"