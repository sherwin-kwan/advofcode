require "pry"

public_keys = open("./25-input.txt").read.split("\n").map { |str| str.to_i }

DIVISOR = 20201227  

def self.encryption_loop(multiplier, loops, divisor, seeking, start = 1)
  num = start
  (1..loops).each do |i|
    num = multiplier * num % divisor
    if num == seeking
      puts "Encrypted to #{num} after #{i} tries" 
      return {loop_size: i, value: num}
    end
  end
  puts "Encrypted result is #{num}"
end

res1 = encryption_loop(7, 10000000, DIVISOR, public_keys[0], 1) # Encrypted to 12232269 after 4173465 tries
res2 = encryption_loop(7, 10000000, DIVISOR, public_keys[1], 1) # Encrypted to 19452773 after 5882067 tries

encryption_loop(res1[:value], res2[:loop_size], DIVISOR, nil, 1) # Encrypted result is 354320
encryption_loop(res2[:value], res1[:loop_size], DIVISOR, nil, 1) # Encrypted result is 354320