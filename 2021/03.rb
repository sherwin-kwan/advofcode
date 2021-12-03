file = "./03.txt"
data = File.open(file).read.split("\n")

def find_common(data, bit)
  total = data.map{|n| n[bit].to_i}.reduce(&:+)
  total >= data.length / 2.0 ? 1 : 0
end

def find_rating(data, is_oxygen)
  (0...data[0].length).each do |position|
    break if data.length == 1
    bit_to_find = is_oxygen ? find_common(data, position) : 1 - find_common(data, position)
    data = data.filter{|l| l[position].to_i == bit_to_find}
  end
  data.first.to_i(2)
end

# Part 1
bits = data[0].length
gamma = [*0...bits].map{|bit| find_common(data, bit)}.join("").to_i(2)
epsilon = 2 ** bits - 1 - gamma
puts gamma * epsilon

# Part 2
oxy = find_rating(data, true)
carb = find_rating(data, false)
puts oxy * carb
