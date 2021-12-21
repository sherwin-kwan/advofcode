data = []
scanners = open("./19.txt").read.split("\n\n").each do
  num = _1.split("\n").first.gsub("--- scanner ", "").gsub(" ---", "").to_i
  data[num] = _1.split("\n").slice(1..-1).map{|row| eval("[#{row}]")}
end

def three_distance(a, b, manhattan = false)
  distances = [(b[0] - a[0]).abs, (b[1] - a[1]).abs, (b[2] - a[2]).abs].sort
  return manhattan ? distances.sum : distances
end

def identify_common_beacons(data, scanner_distances, num1, num2)
  sc1, sc2 = [data[num1], data[num2]]
  distances1, distances2 = [scanner_distances[num1], scanner_distances[num2]]
  union = distances1.map{_1[2]} & distances2.map{_1[2]}
  num_of_common_beacons = (Math.sqrt(8 * union.count + 1) + 1) / 2
  # We now have a collection of tuples like (2, 3), (2, 4), (2, 5) which tell us the indexes of the points scanned by scanner 1 that were also scanned by scanner 2
  unless union.empty?
    common1 = []
    common2 = []
    # If there were 12 common points, then the first 11 elements in union will be tuples containing an "anchor" point and one of the other 11 points
    union.first(num_of_common_beacons - 1).each do |distance|
      common1 << distances1.find{_1[2] == distance}.slice(0, 2).map{_1}
      common2 << distances2.find{_1[2] == distance}.slice(0, 2).map{_1}
    end
    # Find the repeated point, that's the anchor. Then we just need one other point, and we can use the distance between them to determine the axis transformation
    anchor1 = common1.delete(common1.flatten!.tally.sort{|a, b| a.last <=> b.last}.last.first)
    anchor2 = common1.delete(common2.flatten!.tally.sort{|a, b| a.last <=> b.last}.last.first)
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

# Use this method to transform a coordinate into a different axis system, or to transform a transform
# The syntax for a transform uses imaginary parts to specify reversed directions e.g. [2+i, 0+i, 1] means
# the positive x-direction of the first scanner is the negative z-direction of the second scanner
# the positive y-direction of the first scanner is the negative x-direction of the second scanner
# the positive z-direction of the first scanner is the positive y-direction of the second scanner
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
scanner_distances = data.map{|sc| [*0...sc.length].combination(2).map{|a, b| [a, b, three_distance(sc[a], sc[b])]}}
[*0...data.count].combination(2).each do |a, b| 
  try = identify_common_beacons(data, scanner_distances, a, b)
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
  try = identify_common_beacons(data, scanner_distances, b, a)
  if try && scanner_locations[b] && scanner_transforms[b]
    inter = transform(try[:difference], scanner_transforms[b])
    scanner_locations[a] = (0..2).map{ inter[_1] + scanner_locations[b][_1]}
    scanner_transforms[a] = transform(try[:transforms], scanner_transforms[b], true)
  end
end

puts data.sum(&:count) - seen.flatten.uniq.count # Part 1
puts scanner_locations.combination(2).map{|a, b| three_distance(a, b, true)}.max # Part 2
puts Time.now - stamp