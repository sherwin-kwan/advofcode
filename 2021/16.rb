data = open("./16.txt").read.chars.map{'%04b' % _1.to_i(16)}.join("")
p data


def parse_packet(str)
  version = str[0..2].to_i(2)
  value = 0
  length = 0
  id = str[3..5].to_i(2)
  if id == 4
    puts "Literal!"
    result = parse_literal(str[6..])
    value = result[:number]
    length += result[:length] + 6
  else
    if str[6] == "0"
      bits_to_parse = str[7..21].to_i(2)
      result = parse_several_packets(str[22...22 + bits_to_parse], nil, id)
      value = result[:value]
      version += result[:version]
      length += 22 + bits_to_parse
    else
      puts str[7..17].class
      number_of_subpackets = str[7..17].to_i(2)
      result = parse_several_packets(str[18..], number_of_subpackets, id)
      value = result[:value]
      version += result[:version]
      length += 18 + result[:length]
    end
  end=
  return {version: version, length: length, value: value, remainder: str[length..]}
end

def parse_several_packets(str, number_of_subpackets = nil, code)
  versions = []
  lengths = []
  values = []
  if number_of_subpackets
    s = str.dup
    result = nil
    counter = 1
    number_of_subpackets.times do 
      puts "Parsing packet ##{counter}"
      result = parse_packet(s)
      versions << result[:version]
      lengths << result[:length]
      values << result[:value]
      s = result[:remainder]
      counter += 1
    end
  else
    s = str.dup
    result = nil
    counter = 1
    while s.include?("1") do
      puts "Parsing packet indefinitely #{counter}"
      result = parse_packet(s)
      versions << result[:version]
      lengths << result[:length]
      values << result[:value]
      s = result[:remainder]
      counter += 1
    end
  end
  case code
  when 0
    value = values.sum
  when 1
    value = values.reduce(&:*)
  when 2
    value = values.min
  when 3
    value = values.max 
  when 5
    value = values[0] > values[1] ? 1 : 0
  when 6
    value = values[0] < values[1] ? 1 : 0
  when 7
    value = values[1] == values[0] ? 1 : 0
  end
  return {version: versions.sum, length: lengths.sum, value: value, remainder: str[lengths.sum..]}
end

def parse_literal(str)
  output = ""
  counter = 0
  str.chars.each_slice(5) do |group|
    output << group[1..4].join("")
    counter += 1
    break if group[0] == "0"
  end
  return {number: output.to_i(2), length: counter * 5}
end

p parse_packet(data)
# p parse_packet("10110001011")

# 100 111 0 000000000010110 101 100 00101 111 100 01111 0000