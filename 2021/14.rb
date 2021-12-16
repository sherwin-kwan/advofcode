polymer, rules = open("./14.txt").read.split("\n\n")
rules = rules.split("\n").map{_1.split(" -> ")}
combos = []
[*0..polymer.length - 2].each do |i|
  combos << polymer[i] + polymer[i + 1]
end

[10, 40].each do |num|
  list = combos.tally
  num.times do
    output = Hash.new(0)
    list.each do |k, v|
      inserting = rules.filter{_1.first == k}.first.last
      [k[0] + inserting, inserting + k[1]].each{ output[_1] += v}
    end
    list = output
  end
  subtotals = Hash.new(0)
  list.each{|k, v| [k[0], k[1]].each{subtotals[_1] += v}}
  # You will double count all except the first and last character here. Halve every number, and rely on round up to account for first/last chars.
  totals = subtotals.map{|a, b| (b * 0.5).round} 
  puts "#{num} iterations: #{totals.max - totals.min}"
end