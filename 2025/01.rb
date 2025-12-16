require "pry"

time0 = Time.now
turns = File.open('./01.txt').read.split("\n").compact

def parse_turn(turn)
  if turn.chars[0] == 'L'
    return turn.gsub('L', '').to_i * -1
  elsif turn.chars[0] == 'R'
    return turn.gsub('R', '').to_i
  end

  raise "Invalid turn: #{turn}"
end

pos = 50
zeros = 0
passes_of_zero = 0
turns.each do |turn|
  new_pos = (pos + parse_turn(turn))
  if new_pos > 100
    passes_of_zero += ((new_pos - 101) / 100 + 1) # Calculates the number of times we turn past 0
  elsif new_pos < 0
    passes_of_zero += ((-1 - new_pos) / 100)
    passes_of_zero += 1 if pos != 0 # If we were at 0, we don't pass it on the first turn
  end
  pos = new_pos % 100
  zeros += 1 if pos == 0
end
time1 = Time.now
puts "Part 1: #{zeros}"
puts "Part 2: #{zeros + passes_of_zero}"
puts "Time taken: #{time1 - time0}"