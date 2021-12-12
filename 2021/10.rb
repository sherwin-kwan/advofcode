data = open("./10.txt").each_line.map{_1.strip.tr("()[]{}<>", "AaBbCcDd")}

def score(line, part2)
  stack = []
  part1_scores = {"a" => 3, "b" => 57, "c" => 1197, "d" => 25137}
  part2_scores = {"a" => 1, "b" => 2, "c" => 3, "d" => 4}
  line.chars.each do |char|
    if char == char.upcase
      stack << char.downcase
    elsif char == stack.last
      stack.pop
    else
      return part2 ? 0 : part1_scores[char]
    end
  end
  return part2 ? stack.reverse.reduce(0){|acc, val| acc * 5 + part2_scores[val]} : 0
end

puts data.map{score(_1, false)}.sum
part2_arr = data.map{score(_1, true)}.filter{_1 > 0}
puts part2_arr.sort[part2_arr.count / 2]