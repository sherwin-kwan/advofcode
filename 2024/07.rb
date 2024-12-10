def try_equation(eq_arr, ans, combs)
  num_of_operators = eq_arr.length - 1
  combs.each do |comb|
    result = eq_arr[0]
    eq_arr[1..].each_with_index do |n, ind|
      if comb[ind] == "1"
        result = result * n
      elsif comb[ind] == "2"
        result = "#{result}#{n}".to_i
      else
        result = result + n
      end
    end
    return true if result == ans
  end
  return false
end

orig = Time.now

# We use a continuous list of numbers and convert to binary (000, 001, 010, 011, etc.) to get a complete list of all possible combinations of + and *
# To improve performance, only create this list once and look up "8" every time we have an 8-operator equation
# Then evaluate the equation (left-to-right, without order of operations, so can't just use eval) and compare it to the desired answer
combs_of_two = []
combs_of_three = []
(1..11).each do |n|
  combs_of_two[n] = (0...2**n).map{_1.to_s(2).rjust(n, "0").split("")}
  combs_of_three[n] = (0...3**n).map{_1.to_s(3).rjust(n, "0").split("")}
end
puts Time.now - orig

lines = File.open("07.txt").read.split("\n")
lines_to_do_in_p2 = []
p1 = lines.map do |line|
  ans, eq = line.split(": ")
  eq_arr = eq.split(" ").map(&:to_i)
  if try_equation(eq_arr, ans.to_i, combs_of_two[eq_arr.length - 1])
    ans.to_i 
  else 
    lines_to_do_in_p2 << line
    0
  end
end.sum
puts "Part 1: #{p1}"
puts Time.now - orig

p2 = lines_to_do_in_p2.map do |line|
  ans, eq = line.split(": ")
  eq_arr = eq.split(" ").map(&:to_i)
  try_equation(eq_arr, ans.to_i, combs_of_three[eq_arr.length - 1]) ? ans.to_i : 0
end.sum
puts "Part 2: #{p1 + p2}"
puts Time.now - orig