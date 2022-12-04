input = File.open("./03.txt").read.split("\n")

def find_misplaced(str)
  raise "Something wrong!" if str.length % 2 == 1
  comp1 = str[0...str.length/2]
  comp2 = str[str.length/2..-1]
  comp1.split("").each do |char|
    if comp2.include?(char)
      # Found a matching letter
      return priority(char)
    end
  end
end

def find_badge(arr)
  raise "Something wrong!" unless arr.length == 3
  arr[0].split("").each do |char|
    if arr[1].include?(char) && arr[2].include?(char)
      # Found the badge item letter
      return priority(char)
    end
  end
end

def priority(let)
  if let == let.upcase
    # For capital letters, character code is from 65 to 90
    return let.ord - 38
  else
    # For lowercase letters, charactre code is from 97 to 122
    return let.ord - 96
  end
end

puts "Part 1: #{input.map{|line| find_misplaced(line)}.sum}"
puts "Part 2: #{input.each_slice(3).map{|group| find_badge(group)}.sum}"