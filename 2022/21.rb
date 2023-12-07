require "pry"
input = File.open("./21-test.txt").read.split("\n").map{_1.split(": ")}.sort{|a, b| b.last.to_i <=> a.last.to_i}
data = {}
input.each{|line| data[line[0]] = line[1]}
data2 = data.map{_1.dup}

def cycle(hash)
  hash.each do |line|
    key, inst = line
    next if inst.match? /\A[\d]+\z/
    /(\w+)\s[+\-*\/]\s(\w+)/ =~ inst
    if $1.to_i > 0 && $2.to_i > 0
      hash[key] = eval(inst).to_s
    end
    if $1.to_i == 0 && hash[$1]&.match?(/\A[\d]+\z/)
      hash[key] = inst.gsub($1, hash[$1])
    end
    if $2.to_i == 0 && hash[$2]&.match?(/\A[\d]+\z/)
      hash[key] = inst.gsub($2, hash[$2])
    end
  end
end

loop do
  cycle(data)
  break if data["root"].match? /\A[\d]+\z/
end
puts "Part 1: #{data["root"]}"

equation = data2.find{_1.first == "root"}[1].gsub(/[+\-*\/]/, "=")
puts equation