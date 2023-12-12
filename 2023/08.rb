require "prime"
$instructions, data = File.open("./08.txt").read.split("\n\n")
$chart = {}
data.split("\n").each do |line|
  extr = line.scan(/[A-Z][A-Z][A-Z]/)
  $chart[extr[0]] = {L: extr[1], R: extr[2]}
end

def steps_to_arrive(orig, dest) # String, String, String
  loc = orig
  step = 0
  loop do
    char = $instructions.chars[step % ($instructions.length)]
    loc = $chart[loc][char.to_sym]
    return step + 1 if dest == loc
    step += 1
    return -1 if step > 50000
  end
end
# TODO: Replace brute force with a regular occurrences and then we can

# Part 1
puts "Part 1: #{steps_to_arrive("AAA","ZZZ")}"
# Part 2
origins = $chart.keys.filter{_1[2] == "A"}
destinations = $chart.values.map(&:values).flatten.filter{_1[2] == "Z"}
matrix = {}

# Used this to identify that you can't get from __Z to a differen __Z destination!

# destinations.repeated_permutation(2).each do |perm|
#   orig, dest = perm
#   matrix[orig + dest] = steps_to_arrive(orig, dest)
# end
# origins.each do |orig|
#   destinations.each do |dest|
#     matrix[orig + dest] = steps_to_arrive(orig, dest)
#     puts "Setting #{orig} to #{dest} with #{matrix[orig + dest]}"
#   end
# end
# matrix = matrix.filter{|k, v| v != -1}
# pp matrix

# Now returned matrix: 

# AAA to ZZZ: 18023; ZZZ repeats every 18023
# BFA to MGZ: 19637, MGZ repeats every 19637
# DFA to TQZ: 21251, TQZ repeats every 21251
# XFA to BKZ: 16409, BKZ repeats every 16409
# OJA to BNZ: 11567; BNZ repeats every 11567
# SBA to SSZ: 14257; SSZ repeats every 14257
# So we just need the lowest common denominator here
factors = [11567, 14257, 16409, 18023, 19637, 21251]
prime_factors = {}
factors.each do |factor|
  Prime.prime_division(factor).each do |a|
    pr, exp = a # prime number raised to an exponent
    prime_factors[pr] = prime_factors[pr] ? [prime_factors[pr], exp].max : exp
  end
end
puts "Part 2: #{Prime.int_from_prime_division(prime_factors.to_a)}"