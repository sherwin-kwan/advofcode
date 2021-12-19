
data = []
scanners = open("./19.txt").read.split("\n\n").each do
  num = _1.split("\n").first.gsub("--- scanner ", "").gsub(" ---", "").to_i
  data[num] = _1.split("\n").slice(1..-1).map{|row| eval("[#{row}]")}
end

def three_distance(a, b, manhattan = false)
  distances = [(b[0] - a[0]).abs, (b[1] - a[1]).abs, (b[2] - a[2]).abs].sort
  return manhattan ? distances.sum : distances
end

def identify_common_beacons(data, num1, num2)
  sc1, sc2 = [data[num1], data[num2]]
  beacons1 = sc1.count
  beacons2 = sc2.count
  distances1 = [*0...beacons1].combination(2).map{|a, b| [a, b, three_distance(sc1[a], sc1[b])]}
  distances2 = [*0...beacons2].combination(2).map{|a, b| [a, b, three_distance(sc2[a], sc2[b])]}
  union = distances1.map{_1[2]} & distances2.map{_1[2]}
  num_of_common_beacons = (Math.sqrt(8 * union.count + 1) + 1) / 2
  unless union.empty?
    common1 = []
    common2 = []
    union.first(num_of_common_beacons - 1).each do |distance|
      f = distances1.find{_1[2] == distance}.slice(0, 2).map{_1}
      g = distances2.find{_1[2] == distance}.slice(0, 2).map{_1}
      common1 << f
      common2 << g
    end
    anchor1 = common1.flatten!.tally.sort{|a, b| a.last <=> b.last}.last.first
    anchor2 = common2.flatten!.tally.sort{|a, b| a.last <=> b.last}.last.first
    common1.delete(anchor1)
    common2.delete(anchor2)
    sc1_distance = (0..2).map{ sc1[common1.first][_1] - sc1[anchor1][_1] }
    sc2_distance = (0..2).map{ sc2[common2.first][_1] - sc2[anchor2][_1] }
    transforms = (0..2).map{ sc2_distance.map(&:abs).index(sc1_distance[_1].abs)}
    reversed = (0..2).map{ sc2_distance.index( -sc1_distance[_1])}
    (0..2).each{transforms[_1] += 1.i if reversed[_1]}
    anchor2_tr = transform(sc2[anchor2], transforms)
    difference = (0..2).map {sc1[anchor1][_1] - anchor2_tr[_1]}
    return {beacons: [[anchor1], common1, [anchor2], common2].reduce(&:concat), difference: difference, transforms: transforms}
  end
end

def transform(coords, tr, is_meta_transform = nil)
  coords_tr = []
  (0..2).each do |n|
    if is_meta_transform
      coords_tr[n] = tr[n].imaginary == 0 ? coords[tr[n].real] : coords[tr[n].real.abs].imaginary > 0 ? coords[tr[n].real.abs].real : coords[tr[n].real.abs] + 1.i
    else
      coords_tr[n] = tr[n].imaginary > 0 ? -coords[tr[n].real.abs] : coords[tr[n].real]
    end
  end
  coords_tr
end

stamp = Time.now
seen = []
scanner_locations = [[0, 0, 0]]
scanner_transforms = [[0, 1, 2]]
[*0...data.count].combination(2).each do |a, b| 
  try = identify_common_beacons(data, a, b)
  if try
    result = try[:beacons]
    seen << result.slice(result.length / 2..-1).map{_1 + b.i} if result
    if try && scanner_locations[a] && !scanner_locations[b]
      if a == 0
        scanner_locations[b] = try[:difference]
        scanner_transforms[b] = try[:transforms]
      else
        inter = transform(try[:difference], scanner_transforms[a])
        scanner_locations[b] = (0..2).map{ inter[_1] + scanner_locations[a][_1]}
        scanner_transforms[b] = transform(try[:transforms], scanner_transforms[a], true)
      end
    end
  end
end

# Go backwards to fill in any scanner locations that haven't been found yet
(data.count - 1).downto(0).to_a.combination(2).each do |b, a|
  next if scanner_locations[a]
  try = identify_common_beacons(data, b, a)
  if try && scanner_locations[b] && scanner_transforms[b]
    inter = transform(try[:difference], scanner_transforms[b])
    scanner_locations[a] = (0..2).map{ inter[_1] + scanner_locations[b][_1]}
    scanner_transforms[a] = transform(try[:transforms], scanner_transforms[b], true)
  end
end

puts data.sum(&:count) - seen.flatten.uniq.count # Part 1
puts scanner_locations.combination(2).map{|a, b| three_distance(a, b, true)}.max # Part 2
puts Time.now - stamp