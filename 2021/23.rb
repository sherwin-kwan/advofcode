require 'pry'

$valid_points = [*0..10].map{_1 + 0.i}
[2, 4, 6, 8].each do |n|
  [1, 2, 3, 4].each do |i|
    $valid_points << n + i.i
  end
end

$reserved = {
  "A" => 2,
  "B" => 4,
  "C" => 6,
  "D" => 8
}
$counter = 0
$solutions = {}
$stop_at = 46000
init_board = {2 + 1.i => "C", 2 + 2.i => "D", 2 + 3.i => "D", 2 + 4.i => "B", 
  4 + 1.i => "B", 4 + 2.i => "C", 4 + 3.i => "B", 4 + 4.i => "C", 
  6 + 1.i => "D", 6 + 2.i => "B", 6 + 3.i => "A", 6 + 4.i => "A", 
  8 + 1.i => "D", 8 + 2.i => "A", 8 + 3.i => "C", 8 + 4.i => "A",
  }
test_board = {2 + 1.i => "B", 2 + 2.i => "D", 2 + 3.i => "D", 2 + 4.i => "A",
  4 + 1.i => "C", 4 + 2.i => "C", 4 + 3.i => "B", 4 + 4.i => "D",
  6 + 1.i => "B", 6 + 2.i => "B", 6 + 3.i => "A", 6 + 4.i => "C",
  8 + 1.i => "D", 8 + 2.i => "A", 8 + 3.i => "C", 8 + 4.i => "A"}

def energy_to_move(type, origin, dest)
  cost_per_move = 10 ** "ABCD".index(type)
  if origin.imaginary == 0 && dest.imaginary == 0
    (dest - origin).abs * cost_per_move
  elsif origin.imaginary > 0
    energy_to_move(type, origin.real, dest) + origin.imaginary * cost_per_move
  else
    energy_to_move(type, origin, dest.real) + dest.imaginary * cost_per_move
  end
end

def find_moves(board)
  output = []
  board.keys.each do |loc|
    next if board[loc.real - 1.i]
    next if board[loc - 1.i] # Can't move a piece that's blocked behind another piece
    allowed_destinations = []
    reserved_column = $reserved[board[loc]]
    min, max = [loc.real, reserved_column].sort
    if board[reserved_column - 1.i] && (min + 1...max).none?{board[_1]}
      next_spot = [4, 3, 2, 1].find{board[reserved_column + _1.i] == nil}
      allowed_destinations << reserved_column + next_spot.i
    elsif loc.imaginary > 0
      empty_spots = [0, 1, 3, 5, 7, 9, 10].filter{!board[_1]}
      dests = empty_spots.filter do |spot|
        min, max = [spot, loc.real].sort
        [0, 1, 3, 5, 7, 9, 10].filter{(min..max) === _1}.all?{!board[_1]}
      end
      allowed_destinations.concat(dests)
    end
    allowed_destinations.each do |dest|
      output << [loc, dest]
    end
  end
  output
end

def execute_move(origin, dest, board)
  # puts "Executing #{origin} to #{dest} with #{board[origin]}"
  board[dest] = board[origin]
  board.delete(origin)
  if [2, 4, 6, 8].include?(origin.real)
    unless [1, 2, 3, 4].any?{board[origin.real + _1.i] && board[origin.real + _1.i] != $reserved.key(origin.real)}
      board[origin.real - 1.i] = true
    end
  end
end

def solve(board, depth = 0, stamp = nil, prev_moves = [])
  $counter += 1
  stamp = Time.now if depth == 0
  if [2 - 1.i, 4 - 1.i, 6 - 1.i, 8 - 1.i].all?{board[_1]} && [0, 1, 3, 5, 7, 9, 10].none?{board[_1]}
    puts "Board solved!"
    return 0
  else
    moves = find_moves(board)
    return $stop_at if moves.count == 0
    scores = moves.map do |move|
      origin, dest = move
      new_board = board.dup
      energy = energy_to_move(new_board[origin], origin, dest)
      execute_move(origin, dest, new_board)
      score = $solutions[new_board] || solve(new_board, depth + 1, stamp, prev_moves.push(move))
      $solutions[new_board] = score
      if depth < 1
        p [move, score, depth]
      end
      puts Time.now - stamp if depth == 0
      score + energy
    end
    puts $counter if depth < 1
    return scores.min
  end
end

stamp = Time.now
puts solve(init_board, 0, stamp)
puts Time.now - stamp