file = "./04.txt"
nums, *boards = File.open(file).read.split("\n\n")
called = Array.new(100, 0)

def check_for_bingo(board, called)
  options = board.split("\n").map{|line| line.split(" ")}
  options.concat(options.transpose)
  options.each do |option|
    if option.map{|num| called[num.to_i]}.reduce(&:*) > 0
      # Yay a bingo! Return the remaining sum!
      return options.first(5).flatten.map(&:to_i).filter{|num| called[num] == 0}.reduce(&:+)
    end
  end
  0
end

def solve_part_1(nums, boards, called)
  nums.split(",").map(&:to_i).each do |num|
    called[num] = 1
    check_for_win = boards.map{|b| check_for_bingo(b, called)}.reduce(&:+)
    if check_for_win > 0
      puts "We have a bingo!"
      puts num * check_for_win
      return
    end
  end
end

def solve_part_2(nums, boards, called)
  nums.split(",").map(&:to_i).each do |num|
    called[num] = 1
    boards.filter!{|b| check_for_bingo(b, called) == 0}
    if boards.length == 1
      # Only one board left, just pretend it's the only board and use the Part 1 code
      solve_part_1(nums, boards, called)
    end
  end
end

solve_part_1(nums, boards, called)
solve_part_2(nums, boards, called)
