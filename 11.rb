require_relative "exercises"
require "pry"

# Use newline and characters, as a break to create one long array. Note width and length of the original seat arrangement.
# Each seat will be number (width) * (row number) + (seats to the left of this seat on this row)
# Create helper function, which returns the eight adjacent seats's numbers
# Model rule 1 of the algorithm: find all empty seats for which all adjacent seats are empty
# Model rule 2 of the algorithm: find all occupied seats for which four adjacent seats are occupied
# Toggle status of all seats flagged in rules 1 and 2
# Iterate until rules 1 and 2 flag zero seats and an equilibrium is reached

class Exercise11 < Exercises
  raw_data = open("11-input.txt").read
  test_data = open("11-test.txt").read
  example_data = open("11-ex1.txt").read

  def self.parse_seat_data(input_data)
    width = input_data.index("\n")
    data = input_data.gsub!("\n", "").split("").map do |char|
      # Use booleans - now all truthy values are occupied seats
      case char
      when "L" then false
      when "#" then true
      when "." then nil
      end
    end
    total_seats = data.length
    height = total_seats / width
    { data: data, width: width, height: height }
  end

  def self.find_adjacent_seats(num, seats_per_row, rows)
    result = Array.new
    result.push(num - 1) unless num % seats_per_row == 0
    result.push(num + 1) unless (num + 1) % seats_per_row == 0
    unless num / seats_per_row == 0
      result.push(num - seats_per_row)
      result.push(num - seats_per_row - 1) unless num % seats_per_row == 0
      result.push(num - seats_per_row + 1) unless (num + 1) % seats_per_row == 0
    end
    unless num / seats_per_row == rows - 1
      result.push(num + seats_per_row)
      result.push(num + seats_per_row - 1) unless num % seats_per_row == 0
      result.push(num + seats_per_row + 1) unless (num + 1) % seats_per_row == 0
    end
    result.sort
  end

  def self.directional_seats_occupied(num, data, seats_per_row, rows)
    result = Array.new
    column = num % seats_per_row
    row = num / seats_per_row
    # Left
    (column - 1).downto(0).each do |c|
      attempt = seats_per_row * row + c
      # puts "Trying #{attempt}"
      if data[attempt] != nil
        result.push(data[attempt])
        break
      end
    end
    # Right
    (column + 1...seats_per_row).each do |c|
      attempt = seats_per_row * row + c
      # puts "Trying #{attempt}"
      if data[attempt] != nil
        result.push(data[attempt])
        break
      end
    end
    # Top
    (row - 1).downto(0).each do |r|
      attempt = r * seats_per_row + column
      # puts "Trying #{attempt}"
      if data[attempt] != nil
        result.push(data[attempt])
        break
      end
    end
    # Top-Left
    n = [row, column].min
    (1..n).each do |i|
      attempt = (row - i) * seats_per_row + (column - i)
      # puts "Trying #{attempt}"
      if data[attempt] != nil
        result.push(data[attempt])
        break
      end
    end
    # Top-Right
    n = [row, seats_per_row - column - 1].min
    (1..n).each do |i|
      attempt = (row - i) * seats_per_row + (column + i)
      # puts "Trying #{attempt}"
      if data[attempt] != nil
        result.push(data[attempt])
        break
      end
    end
    # Bottom
    (row + 1...rows).each do |r|
      attempt = r * seats_per_row + column
      # puts "Trying #{attempt}"
      if data[attempt] != nil
        result.push(data[attempt])
        break
      end
    end
    # Bottom-Left
    n = [rows - row - 1, column].min
    (1..n).each do |i|
      attempt = (row + i) * seats_per_row + (column - i)
      # puts "Trying #{attempt}"
      if data[attempt] != nil
        result.push(data[attempt])
        break
      end
    end
    # Bottom-Right
    n = [rows - row - 1, seats_per_row - column - 1].min
    (1..n).each do |i|
      attempt = (row + i) * seats_per_row + (column + i)
      # puts "Trying #{attempt}"
      if data[attempt] != nil
        result.push(data[attempt])
        break
      end
    end
    result.count { |n| n }
  end

  def self.adjacent_seats_occupied(num, data, seats_per_row, rows)
    adjacent = find_adjacent_seats(num, seats_per_row, rows)
    adjacent.map { |num| data[num] }.count { |n| n }
  end

  def self.seats_to_toggle(data, seats_per_row, rows, seats_occupied_trigger)
    flags = Array.new
    (0...data.length).each do |num|
      if data[num]
        # Only occupied seats will be truthy and counted
        # This function needs to be changed to use adjacent_seats_occupied in the original scenario
        flags.push num if directional_seats_occupied(num, data, seats_per_row, rows) >= seats_occupied_trigger
      elsif data[num] == false
        flags.push num if directional_seats_occupied(num, data, seats_per_row, rows) == 0
      end
    end
    p flags
    flags
  end

  def self.toggle_seats(data, seats_per_row, rows, seats_occupied_trigger)
    toggle = seats_to_toggle(data, seats_per_row, rows, seats_occupied_trigger)
    return [] if toggle.length == 0
    puts "Toggling seats: "
    p toggle
    next_data = data.map.with_index do |seat, index|
      if toggle.include?(index)
        !seat
      else
        seat
      end
    end
  end

  def self.main(data, seats_per_row, rows, seats_occupied_trigger)
    counter = 1
    loop do
      new_data = toggle_seats(data, seats_per_row, rows, seats_occupied_trigger)
      if new_data == []
        break
      else
        puts "Completed operation #{counter}"
        data = new_data
        counter += 1
      end
    end
    puts "Equilibrium reached after #{counter} operations! #{data.count { |n| n }} seats are occupied"
  end


  data, width, height = parse_seat_data(raw_data).values_at(:data, :width, :height)
  data2, width2, height2 = parse_seat_data(test_data).values_at(:data, :width, :height)

  main(data, width, height, 5) # Equilibrium reached after 91 operations! 2285 seats are occupied

  # main(data, width, height) # Output: Equilibrium reached! 2483 seats are occupied (85 operations later)
end
