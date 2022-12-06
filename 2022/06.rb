require "pry"

string = File.open("./06.txt").read

def first_marker(string, cons_uniq_chars)
  (cons_uniq_chars - 1...string.length).each do |n|
    return n+1 if string[n-(cons_uniq_chars-1)..n].split("").uniq.count == cons_uniq_chars
  end
end

puts "Part 1: #{first_marker(string, 4)}"
puts "Part 2: #{first_marker(string, 14)}"