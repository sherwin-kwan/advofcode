require_relative "exercises"
require "pry"

# parse the file, first by newline, then turn the second line into an array with a splat
# replace all the Xs with 0 and type-cast to numeric
# sort the array to get a series of bus numbers
# create a second array, with number - timestamp % number, to find the number of minutes you have to wait for that bus
# find the shortest wait time and multiply it by the bus number

# Part B:
# Extract the index of the bus numbers from the raw data
# Define the "anchor" as the number which corresponds to the first entry in the raw data array ("23")
# Starting from the largest number, figure out what the anchor modulo this number would be
# Next, introduce the second-largest number. Figure out what the anchor modulo this number would be. 
# Find the LCM of the two numbers, and identify a unique value between 0 and the LCM that makes both the modulos correct.
# Now we know that the anchor should have this modulo when divided by the LCM.
# Iterate onwards through the array, each time finding the LCM of the accumulated LCM and the next number. 
# You should end up with one possible value for the anchor, this is the solution

class Exercise13 < Exercises
  def self.parse_text(fn)
    data = parse_file(fn, /[\n,]/, false)
    timestamp = data.slice!(0).to_i
    data.map! {|str| str.to_i} # Xs will turn into zeroes
    { timestamp: timestamp, data: data }
  end

  def self.find_buses(data)
    sorted_data = data.sort { |a, b| b <=> a}
    first_zero = sorted_data.index(0)
    sorted_data.slice(0, first_zero) # Discard the trailing zeroes
  end

  def self.wait_times(timestamp, buses)
    buses.map do |num|
      num - timestamp % num
    end
  end

  def self.solveA(timestamp, buses)
    wait_times = wait_times(timestamp, buses)
    index_of_quickest_bus = wait_times.index(wait_times.min)
    quickest_bus = buses[index_of_quickest_bus]
    puts "#{wait_times.min} minute wait to catch bus #{quickest_bus}, so the answer is #{wait_times.min * quickest_bus}"
  end

  def self.solveB(data, buses)
    buses_with_modulo = buses.map do |num|
      # For example, if the number 41 appears at index 13, that means that the anchor, when divided by 41, will have remainder (modulo) 41-23 = 18
      {bus: num,
      mod: (num - data.index(num)) % num}
    end
    solution = buses_with_modulo.reduce do |acc, val|
      p acc
      lcm = acc[:bus].lcm(val[:bus])
      (0...val[:bus]).each do |num|
        candidate = num * acc[:bus] + acc[:mod]
        if candidate % val[:bus] == val[:mod]
          acc = {
            bus: lcm,
            mod: candidate
          }
          puts "Candidate #{candidate} successful"
          break
        end
      end
      acc
    end
    puts "The lowest anchor is #{solution}"
  end

  timestamp, data = parse_text("./13-input.txt").values_at(:timestamp, :data)
  solveA(timestamp, find_buses(data)) # Output: 11 minute wait to catch bus 733, so the answer is 8063
  solveB(data, find_buses(data)) # Output: The lowest anchor is {:bus=>1398323334468437, :mod=>775230782877242}
end
