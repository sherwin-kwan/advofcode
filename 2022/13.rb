pairs = File.open("./13.txt").read.split("\n\n")

def ordered(a, b)
  if a.class == Integer && b.class == Integer
    return a > b ? 0 : b > a ? 1 : nil
  else 
    a = [a] if a.class != Array
    b = [b] if b.class != Array
    l = [a.length, b.length].min
    (0...l).each{|i| return ordered(a[i], b[i]) if ordered(a[i], b[i])}
    return a.length > b.length ? 0 : b.length > a.length ? 1 : nil
  end
end

good_indices = pairs.each_with_index.map do |pair, index|
  x, y = pair.split("\n").map{eval(_1)}
  ordered(x, y) * (index + 1)
end

sorted_pairs = pairs.map{_1.split("\n").map{|l| eval(l)}}.reduce(&:+).concat([[[2]], [[6]]]).sort{|a, b| ordered(b, a)*2 - 1}
puts "Part 1: #{good_indices.reduce(&:+)}"
puts "Part 2: #{(sorted_pairs.find_index([[2]]) + 1) * (sorted_pairs.find_index([[6]]) + 1)}"