line1, line2 = File.open("01.txt").read.split("\n").map{_1.split(" ")}
  .transpose
  .map{_1.map(&:to_i).sort}

total = (0...line1.length).map{|n| (line2[n] - line1[n]).abs}.sum
puts "Part 1: #{total}"

frequencies = line2.tally
total = (0...line1.length).map{|n| (frequencies[line1[n]] || 0) * line1[n]}.sum
puts "Part 2: #{total}"