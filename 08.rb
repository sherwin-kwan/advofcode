rows = File.open("08.txt").read.split("\n")
antennas = {}
rows.each_with_index do |row, a|
  row.chars.each_with_index do |char, b|
    if char != "."
      if antennas[char] 
        antennas[char] << a + b.i
      else
        antennas[char] = [a + b.i]
      end
    end
  end
end
ROWS = rows.count
COLS = rows[0].length

def in_puzzle?(pos)
  pos.real >= 0 && pos.real < ROWS && pos.imaginary >= 0 && pos.imaginary < COLS
end

def calc_antipodes_v1(a, b)
  return [2 * b - a, 2 * a - b].filter{in_puzzle?(_1)}
end

def calc_antipodes_v2(a, b)
  distance_between = b - a
  gcd = distance_between.real.gcd(distance_between.imaginary)
  basic_unit = distance_between / gcd
  podes = []
  podes << a # A is always an antenna
  pos = a
  # Go from A away from B
  loop do 
    pos = pos - basic_unit
    break unless in_puzzle?(pos)
    podes << pos
  end
  pos = a
  # Go from A in the direction of B
  loop do 
    pos = pos + basic_unit
    break unless in_puzzle?(pos)
    podes << pos
  end
  return podes
end

antipodes_v1 = []
antipodes_v2 = []
antennas.values.each do |val|
  val.combination(2).each do |comb|
    antipodes_v1.concat(calc_antipodes_v1(comb[0], comb[1]))
    antipodes_v2.concat(calc_antipodes_v2(comb[0], comb[1]))
  end
end
puts "Part 1: #{antipodes_v1.uniq.count}"
puts "Part 2: #{antipodes_v2.uniq.count}"