# Begin with a set of strings in F/B, R/L format
# Convert each string to binary by replacing B and R with 1, F and L with 0
# Convert the binary number to decimal to reveal the seat numbers
# Sort and find the "missing" seat number

class Exercise5
  data = open("05-input.txt").read.split("\n")  # Array of rows

  def self.get_seat_array(arr)
    seats = arr.map do |seat|
      seat.gsub!(/[FL]/, "0")
      seat.gsub!(/[BR]/, "1")
      # Now we have a seat number in binary. Next convert to decimal
      seat.to_i(2)
    end
    seats = seats.sort
  end

  def self.find_missing_seat(arr)
    # The last number of a sorted array will be the highest seat number
    puts "The highest seat number is #{arr[-1]}"
    (arr[0]..arr[-1]).each do |seat_num|
      unless arr.index(seat_num)
        puts "Seat #{seat_num} is missing"
        return nil
      end
    end
    puts "Couldn't find seat number"
  end

  find_missing_seat(get_seat_array(data))
  # Output: The highest seat number is 816
  # Seat 539 is missing

end
