lines = File.open("06.txt").read.split("\n")
room = {}
guard_pos = nil
guard_dir = 0 # going north/up
obstacle_placement = []
room["max_row"] = lines.count - 1
room["max_col"] = lines[0].length - 1
lines.each_with_index do |line, a|
  line.chars.each_with_index do |char, b|
    case char
    when "#"
      room[a+b.i] = true
    when "."
      room[a+b.i] = false
    when "^"
      room[a+b.i] = false
      guard_pos = a + b.i
    end
  end
end

def test_guard(room, guard_pos, guard_dir)
  guard_visited = {}
  loop do
    case guard_dir
    when 0
      next_pos = guard_pos - 1
    when 1
      next_pos = guard_pos + 1.i
    when 2
      next_pos = guard_pos + 1
    when 3
      next_pos = guard_pos - 1.i
    end
    if room[next_pos] # Obstacle ahead
      guard_dir = (guard_dir + 1) % 4 # If an obstacle is hit, turn right
    else
      if guard_visited[guard_pos]
        raise "There will be a loop" if guard_visited[guard_pos].include?(guard_dir)
        guard_visited[guard_pos] << guard_dir 
      else 
        guard_visited[guard_pos] = [guard_dir]
      end
      guard_pos = next_pos
    end
    return guard_visited if next_pos.real > room["max_row"] || next_pos.real < 0
    return guard_visited if next_pos.imaginary > room["max_col"] || next_pos.imaginary < 0
  end
end

official_map_guard_visited = test_guard(room, guard_pos, guard_dir)
puts "Part 1: #{official_map_guard_visited.count}"

# This is a naive solution, iterating through each possible place an obstacle can be put by brute force
# TODO: Alternate way of doing this that takes into account where the obstacles are, and which ones have been hit already
official_map_guard_visited.keys.each do |potential_obstacle_spot|
  test_room = room.dup
  test_room[potential_obstacle_spot] = true
  begin
    test_guard(test_room, guard_pos, guard_dir)
  rescue => e
    obstacle_placement << potential_obstacle_spot
  end
end

puts "Part 2: #{obstacle_placement.length}"