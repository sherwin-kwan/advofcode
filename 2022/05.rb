stacks, instructions = File.open("./05.txt").read.split("\n\n").map{_1.split("\n").select{|l| l.strip.length > 0}}

# Begin by modelling each stack of boxes as an array, with the bottom box first so we can easily push/pop the top boxes
stacks = stacks[0..-2].reverse # Remove the last line which is the "1 2 3 ..."
stack_array = Array.new(10){[]}
stacks.each do |line|
  (1..9).each do |n|
    char = line[n*4-3]
    stack_array[n] << char if char && char != " "
  end
end
stack_array2 = Marshal.load(Marshal.dump(stack_array)) # Creates a deep copy

# Extract the numbers from the "move X from Y to Z" instructions
def parse(inst)
  numeric = inst.gsub(/move|from|to/, "").split(" ").map(&:to_i)
  {boxes_to_move: numeric[0], from: numeric[1], to: numeric[2]}
end

def execute_instruction(inst:, arr:, part:)
  boxes_being_moved = arr[inst[:from]].pop(inst[:boxes_to_move])
  boxes_being_moved = boxes_being_moved.reverse if part == 1
  arr[inst[:to]].push(*boxes_being_moved)
end

instructions.each {execute_instruction(inst: parse(_1), arr: stack_array, part: 1)}
puts "Part 1: #{stack_array[1..9].map(&:last).join}"
instructions.each {execute_instruction(inst: parse(_1), arr: stack_array2, part: 2)}
puts "Part 2: #{stack_array2[1..9].map(&:last).join}"