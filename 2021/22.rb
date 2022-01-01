stamp = Time.now
data = open("./22.txt").each_line.map{_1.strip.gsub(/\s\w=/, ",").gsub(/,\w=/, ",").split(",").map{|n| n[0] == "o" ? n : eval(n)}}

# Part 1 
data_sample = data.filter{_1[1].first >= -50 && _1[1].last <= 50}
# p data.count
# onoff = Hash.new(false)
# data_sample.each do |instruction|
#   instruction[1].each do |x|
#     instruction[2].each do |y|
#       instruction[3].each do |z|
#         onoff[[x,y, z]] = instruction[0] == "on" ? true : false
#       end
#     end
#   end
# end

# Part 2

# x_bins = data.map{[_1[1].first, _1[1].last + 1]}.flatten.sort


x_min = data.map{_1[1].first}.min
x_max = data.map{_1[1].last}.max
y_min = data.map{_1[2].first}.min
y_max = data.map{_1[2].last}.max
z_min = data.map{_1[3].first}.min
z_max = data.map{_1[3].last}.max
handled = []
x_bins = []
y_bins = []
z_bins = []
data.reverse.each do |instruction|
  unless handled.any?{_1[1] === instruction[1].first} && handled.any?{_1[2] === instruction[2].first} && handled.any?{_1[3] === instruction[3].first}
    x_bins << instruction[1].first
    y_bins << instruction[2].first
    z_bins << instruction[3].first
  end
  unless handled.any?{_1[1] === instruction[1].last + 1} && handled.any?{_1[2] === instruction[2].last + 1} && handled.any?{_1[3] === instruction[3].last + 1}
    x_bins << instruction[1].last + 1
    y_bins << instruction[2].last + 1
    z_bins << instruction[3].last + 1
  end
  handled << instruction
end

x_bins = data.map{[_1[1].first, _1[1].last + 1]}.flatten
y_bins = data.map{[_1[2].first, _1[2].last + 1]}.flatten
z_bins = data.map{[_1[3].first, _1[3].last + 1]}.flatten

x_bins.sort!
y_bins.sort!
z_bins.sort!

counter = 0
p x_bins.length, y_bins.length, z_bins.length
p x_bins, y_bins, z_bins
x_bins.each_with_index do |x, xi|
  puts "Doing index #{xi}"
  puts Time.now - stamp
  break if xi == x_bins.count - 1
  y_bins.each_with_index do |y, yi|
    # puts "At y index #{yi}"
    break if yi == y_bins.count - 1
    z_bins.each_with_index do |z, zi|
      break if zi == z_bins.count - 1
      data.reverse.each do |instruction|
        if instruction[1] === x && instruction[2] === y && instruction[3] === z
          counter += instruction[0] == "on" ? (x_bins[xi + 1] - x) * (y_bins[yi + 1] - y) * (z_bins[zi + 1] - z) : 0
          break
        end
      end
    end
  end
end

p counter
puts Time.now - stamp