# Initialize a 3D array to store the states of each cube using this code:
# (ZZXXYY coordinates) 202020: the top left corner of the original layer. The bottom right would be 202727,
# 21xxxx is one layer above, 19xxxx is one layer below
# Parse input file by newline to get a 2D array of initial states
# For each #, set the appropriate key in the hash to true
# Have a helper function that returns an array of 26 neighbouring keys (encoded as a string e.g. "202727")
# Have a helper function that takes an array of neighbouring keys, and returns the # of cubes that are active
# Have a state variable that defines the currently active zone
# 3rd function: iterate in 3 dimensions to the currently active zone and the adjacent cubes, 1 unit further in each direction X, Y, Z on both + and - sides
# For each cube in this iteration, use the 2 helper functions to figure out which ones shall toggle, and return an array of these
# For each cycle, call this 3rd function and use the returned array to toggle cubes
# Iterate for 6 cycles
# Write a function, which takes a min and max X, Y, and Z coordinate, and prints the number of active cubes (true) within
# Call this function after 6 cycles to print the answer

# PART 2:
# Refactor all functions to use 4 dimensions
# Function will now output two counts: one for 3D space and one for 4D space

require_relative "exercises"

# Helpers for exercise 17
module Exercise17Helpers
  def extend_range(range)
    Range.new(range.min - 1, range.max + 1, false)
  end

  def expand_active_zone(hash, four_dimensions)
    hash.map do |key, val|
      if four_dimensions
        hash[key] = extend_range(val)
      else
        hash[key] = extend_range(val) unless key == :w
      end
    end
  end

  def find_neighbours(coordinates, four_dimensions)
    neighbours = Array.new
    w = coordinates.slice(0, 2).to_i
    z = coordinates.slice(2, 2).to_i
    x = coordinates.slice(4, 2).to_i
    y = coordinates.slice(6, 2).to_i
    w_range = (four_dimensions) ? (w - 1..w + 1) : (w..w)
    w_range.each do |h|
      (z - 1..z + 1).each do |k|
        (x - 1..x + 1).each do |i|
          (y - 1..y + 1).each do |j|
            neighbours.push(h.to_s + k.to_s + i.to_s + j.to_s)
          end
        end
      end
    end
    neighbours.delete(coordinates)
    neighbours
  end

  def count_active_neighbours(neighbours, states )
    neighbour_states = neighbours.map { |coord| states[coord] }
    neighbour_states.count { |n| n }
  end


  def current_active_cubes(states, four_dimensions)
    if four_dimensions
      states.values.count{|n| n}
    else
      states.keys.count do |key|
        key.slice(0, 2) == "20" && states[key]
      end
    end
  end
end

class Exercise17 < Exercises
  extend Exercise17Helpers

  @states = Hash.new
  STARTING_COORDINATE = 20
  STARTING_HEIGHT = 8
  STARTING_WIDTH = 8

  # Note, two-digit coordinates assumed. Trying to use (9, 9, 9) will fail during integer to string conversions, so make sure coordinates
  # are big enough that even after N cycles, nothing lower than x/y/z = 10 will be active
  @active_zone = {
    w: (STARTING_COORDINATE..STARTING_COORDINATE),
    x: (STARTING_COORDINATE..STARTING_COORDINATE + STARTING_WIDTH - 1),
    y: (STARTING_COORDINATE..STARTING_COORDINATE + STARTING_HEIGHT - 1),
    z: (STARTING_COORDINATE..STARTING_COORDINATE)
  }

  def self.load_input(fn)
    rows = parse_file(fn, "\n", false)
    starting_config = rows.map {|row| row.split("")}
    starting_config.each_with_index do |row, row_index|
      row.each_with_index do |starting_state, col_index|
        address = STARTING_COORDINATE.to_s + STARTING_COORDINATE.to_s + (STARTING_COORDINATE + row_index).to_s + (STARTING_COORDINATE + col_index).to_s
        @states[address] = true if starting_state == "#"
      end
    end
  end

  def self.execute_cycle(four_dimensions)
    expand_active_zone(@active_zone, four_dimensions)
    toggle_staging = Array.new
    @active_zone[:w].each do |h|
      @active_zone[:z].each do |k|
        @active_zone[:x].each do |i|
          @active_zone[:y].each do |j|
            address = h.to_s + k.to_s + i.to_s + j.to_s
            active_neighbours = count_active_neighbours(find_neighbours(address, four_dimensions), @states)
            if @states[address]
              toggle_staging.push(address) unless (2..3).include? active_neighbours
            else
              toggle_staging.push(address) if active_neighbours == 3
            end
          end
        end
      end
    end
    toggle_staging.each do |address|
      @states[address] = !@states[address]
    end
    # p @states
    puts "Currently there are #{current_active_cubes(@states, true)} active cubes"
  end

  load_input("./17-input.txt")

  # Only run one of the following two commands at a time. This program does not reset state variables after it runs.
  # 3D calculation
  # 6.times { execute_cycle(false) } # Output: Currently there are 382 active cubes
  # 4D calculation
  6.times { execute_cycle(true) } # Currently there are 2552 active cubes

end
