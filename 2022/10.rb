input = File.open("./10.txt").each_line.map{_1.split(" ")}

x = 1
cycle = 1
archive = []
input.each do |inst|
  archive[cycle] = x
  if inst[0] == "addx"
    archive[cycle+1] = x
    cycle += 2
    x += inst[1].to_i
  else # noop
    cycle += 1
  end
end
final = [20, 60, 100, 140, 180, 220].map{_1 * archive[_1]}.sum
puts "Part 1: #{final}"
# Note that this converts from one-based to zero-based indexing, which makes the modulo work (since the CRT now draws at position zero in cycle 0)
lit_pattern = archive[1..240].each_with_index.map{|x, ind| (x-ind%40).abs <= 1 ? "#" : "."}
File.open("./10-res.txt", "w") do |f|
  lit_pattern.each_slice(40) do |row|
    f << row.join
    f << "\n"
  end
end