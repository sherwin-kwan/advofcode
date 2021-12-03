data = File.open("23-input.txt").read
max_num = 1000000
abc = Time.now

# Part 1
def generate_initial_list(str, first_num, last_num)
  list = []
  (1..9).each do |num|
    list[num] = num == last_num ? 10 : str[(str.index(num.to_s) + 1) % 9 ].to_i
    # Simulate a linked list by putting the number of the next cup immediately clockwise of cup N at position N in an array
  end
  (10...1000000).each{|num| list[num] = num + 1}
  list[1000000] = first_num
  list
end

list = generate_initial_list(data, data[0].to_i, data[8].to_i)
current_cup = data[0].to_i

10000000.times do
  # Find the 3 cups which move
  first_cup_to_move = list[current_cup]
  second_cup_to_move = list[first_cup_to_move]
  third_cup_to_move = list[second_cup_to_move]
  destination_cup = current_cup
  loop do
    destination_cup -= 1
    destination_cup = max_num if destination_cup == 0
    break unless [first_cup_to_move, second_cup_to_move, third_cup_to_move].include?(destination_cup)
  end
  # puts "Moving #{first_cup_to_move}, #{second_cup_to_move}, #{third_cup_to_move} beside #{destination_cup}"
  # Reassign the pointers
  list[current_cup] = list[third_cup_to_move]
  list[third_cup_to_move] = list[destination_cup]
  list[destination_cup] = first_cup_to_move
  # Set the current cup one place clockwise
  current_cup = list[current_cup]
end

puts "Ordering of cups clockwise from 1"
p [list[1], list[list[1]]]
puts list[1] * list[list[1]]
puts Time.now - abc