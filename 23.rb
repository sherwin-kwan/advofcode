# Begin with an array of cups
# Have a state variable for the current cup
# Splice the next three cups out of the array
# Identify destination cup
# Insert the three cups after the destination cup
# Iterate 100 times

require 'pry'

class Exercise 23

  data = open("./23-input.txt").read.chomp.split("").map! {|str| str.to_i}
  # data = "389125467".split("").map! {|str| str.to_i}
  @cups = data
  @current_index = 0

  def self.remove_cups
    case @current_index
    when 6
      @cups.slice!(7, 2).push @cups.slice!(0)
    when 7
      [@cups.slice!(8)].concat @cups.slice!(0, 2)
    when 8
      @cups.slice!(0, 3)
    else
      @cups.slice!(@current_index + 1, 3)
    end
  end

  100.times do 
    current_cup = @cups[@current_index]
    cups_to_move = remove_cups
    destination = current_cup == @cups.min ? @cups.index(@cups.max) : @cups.index(current_cup - 1) || @cups.index(current_cup - 2) || @cups.index(current_cup - 3) || @cups.index(current_cup - 4)
    puts "Middle"
    p @cups
    @cups.insert(destination + 1, *cups_to_move)
    @current_index = (@cups.index(current_cup) + 1) % 9
    puts "End of iteration"
    p @cups
  end

  @cups.push *@cups.slice!(0...@cups.index(1))
  puts "final arrangement clockwise from cup 1: #{@cups.slice(1..-1).join("")}" # Output: final arrangement clockwise from cup 1: 72496583

end


