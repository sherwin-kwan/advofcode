input = File.open("./15.txt").read.split("\n")
sensors = []
beacons = []
min_x = 0
max_x = 0
test_line = 2000000
input.each do |line|
  /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/ =~ line
  a, b, c, d = [$1.to_i, $2.to_i, $3.to_i, $4.to_i]
  distance = (c-a).abs + (d-b).abs
  min_x = a - distance if (a - distance) < min_x
  max_x = a + distance if (a + distance) > max_x
  sensors << {sensor: a+b*1i, distance: distance}
  beacons << c if d == test_line && !beacons.include?(c)
end
# sensor_min = sensors.map{_1[:sensor].real}.min
# min_x = sensor_min if sensor_min < min_x
# sensor_max = sensors.map{_1[:sensor].real}.max
# max_x = sensor_max if sensor_max > max_x
pp [min_x, beacons, max_x]
pp sensors

# impossible = 0
# (min_x..max_x).each do |x|
#   if sensors.any?{|sensor| (sensor[:sensor].real-x).abs + (sensor[:sensor].imaginary-test_line).abs <= sensor[:distance]}
#     impossible += 1
#     next
#   end
# end

# puts "Part 1: #{impossible - beacons.count}"